-- create or replace storage integration s3_int
--   TYPE = EXTERNAL_STAGE
--   STORAGE_PROVIDER = S3
--   ENABLED = TRUE 
--   STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::263130564936:role/SnowflakeAwsAccessRole'
--   STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakeawsaccess/csv/', 's3://snowflakeawsaccess/json/', 's3://snowflakeawsaccess/pipes/csv/', 's3://snowflakeawsaccess/files/')
--    COMMENT = 'This an optional comment';
   
   
// See storage integration properties to fetch external_id so we can update it in S3
   
// See storage integration properties to fetch external_id so we can update it in S3
DESC integration s3_int;

CREATE DATABASE IF NOT EXISTS s3loaddb;
CREATE OR REPLACE SCHEMA s3loaddb.external_staging;
CREATE OR REPLACE SCHEMA s3loaddb.staging;
CREATE OR REPLACE SCHEMA s3loaddb.load_control;

-- DROP SCHEMA IF EXISTS s3loaddb.load_control_configs;

CREATE or REPLACE TABLE s3loaddb.load_control.load_control_config
(
stage_table_name string,
schema_name string,
database_name string,
storage_int string,
storage_loc string,
files_typ string,
files_pattern string,
field_delim string,
on_error string,
skip_header int,
force boolean,
truncate_cols boolean,
is_active boolean,
PRIMARY KEY(stage_table_name, schema_name, database_name)
);

CREATE OR REPLACE TABLE s3loaddb.staging.customer_data 
(
customerid NUMBER,
custname STRING,
email STRING,
city STRING,
state STRING,
DOB DATE
);

CREATE OR REPLACE TABLE s3loaddb.staging.pets_data_raw 
(raw_file variant);

CREATE OR REPLACE TABLE s3loaddb.staging.emp_data 
(
  id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  location STRING,
  department STRING
);

CREATE OR REPLACE TABLE s3loaddb.staging.customer
(
customerid NUMBER,
custname STRING,
email STRING,
city STRING,
state STRING,
DOB DATE
);

INSERT INTO s3loaddb.load_control.load_control_config VALUES
('customer_data', 'staging', 's3loaddb', 's3_int', 's3://snowflakeawsaccess/csv/', 'csv', '.*customer.*', '|', 'CONTINUE', 1, True, True, True),
('pets_data_raw', 'staging', 's3loaddb', 's3_int', 's3://snowflakeawsaccess/json/', 'json', '.*pets_data.*', Null, 'CONTINUE', Null, True, True, True),
('emp_data', 'staging', 's3loaddb', 's3_int', 's3://snowflakeawsaccess/pipes/csv/', 'csv', '.*sp_employee.*', '\,', 'CONTINUE', 1, True, True, True),
('customer', 'staging', 's3loaddb', 's3_int', 's3://snowflakeawsaccess/files/', 'csv', '.*customer_.*', '|', 'CONTINUE', 1, True, True, True)
;

-- TRUNCATE TABLe s3loaddb.load_control.load_control_config;

SELECT * FROM s3loaddb.load_control.load_control_config;

// CREATING STORED PROCEDURE
CREATE OR REPLACE PROCEDURE s3loaddb.staging.sp_automate_data_load()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS

DECLARE
    cursr CURSOR FOR SELECT * FROM s3loaddb.load_control.load_control_config WHERE is_active=True;
    tbl string;
    sch string;
    db string;
    st_int string;
    st_loc string;
    file_typ string;
    file_pat string;
    fld_dlm string;
    skp_hdr string;
    forc string;
    on_err string;
    trun_col string;
    cnt integer;
    ret string;
    file_format1 string;
    copy_stmt string;
    create_stage_stmt string;
    fp string;

BEGIN
    ret := '';
    FOR rec IN cursr
    DO
    	tbl := rec.stage_table_name;
    	sch := rec.schema_name;
    	db := rec.database_name;
    	st_int := rec.storage_int;
    	st_loc := rec.storage_loc;
    	file_typ := rec.files_typ;
    	file_pat := rec.files_pattern;
    	fld_dlm := rec.field_delim;
    	skp_hdr := rec.skip_header;
    	forc := rec.force;
    	on_err := rec.on_error;
    	trun_col := rec.truncate_cols;

        IF(:file_typ = 'csv') THEN
		  file_format1 := '(type='||:file_typ||' skip_header='||:skp_hdr||' field_delimiter=\''||:fld_dlm||'\' empty_field_as_null = TRUE)';
	    ELSE
		  file_format1 := '(type='||:file_typ||')';
    	END IF;
        create_stage_stmt := 'CREATE OR REPLACE TEMPORARY STAGE s3loaddb.external_staging.s3_stage
        	URL = \''|| :st_loc || '\'
        	STORAGE_INTEGRATION = '|| :st_int ||'
        	FILE_FORMAT = ' ||:file_format1 ;
        EXECUTE IMMEDIATE create_stage_stmt;
        
        fp := substring(:file_pat, 3, length(:file_pat)-4);
        LIST @s3loaddb.external_staging.s3_stage;
        SELECT COUNT(1) INTO cnt FROM TABLE(result_scan(last_query_id()));
	
    	IF (:cnt > 0) THEN
    
            copy_stmt := 'COPY INTO '||:db||'.'||:sch||'.'||:tbl || '
    		FROM @s3loaddb.external_staging.s3_stage
    		pattern = \'' || :file_pat || '\' 
    		ON_ERROR = ' || :on_err  || '
    		FORCE = ' || :forc  || '
    		TRUNCATECOLUMNS = ' || :trun_col 
            ;
    
           EXECUTE IMMEDIATE copy_stmt;
    		
    	   ret := :ret || :fp || ' Format files completed successfully. \n';
    	ELSE
    	   ret := :ret || :fp || ' Format files not present in the external stage. \n';
    	END IF;
    END FOR;
    RETURN :ret;
END;

select count(1) from s3loaddb.staging.customer_data; -- 0
select count(1) from s3loaddb.staging.pets_data_raw; -- 0
select count(1) from s3loaddb.staging.emp_data; -- 0
select count(1) from s3loaddb.staging.customer; -- 0

CALL s3loaddb.staging.sp_automate_data_load();

select count(1) from s3loaddb.staging.customer_data; -- 100
select count(1) from s3loaddb.staging.pets_data_raw; -- 2
select count(1) from s3loaddb.staging.emp_data; -- 300
select count(1) from s3loaddb.staging.customer; -- 100


-- Automate this process to run every day
CREATE OR REPLACE TASK s3loaddb.staging.task_automate_data_load
SCHEDULE = 'USING CRON 0 7 * * * UTC'
AS
CALL s3loaddb.staging.sp_automate_data_load();