-- Loading Data
    -- Bulk Loading
    -- Continous Loading

-- Stages
    -- Not to be confused with data warehouse stages
    -- Location of data files where data can be loaded from
    -- Can store database objects, URLs, Access Settings Etc.

    -- External: Example S3, Azure, Google Cloud others
    -- Internal: Local storage maintained by Snowflake

USE ROLE SYSADMIN;
USE WAREHOUSE FIRST_WAREHOUSE;
// Database to manage stage objects, fileformats etc.
CREATE OR REPLACE DATABASE MANAGE_DB;
CREATE OR REPLACE SCHEMA external_stages;
USE DATABASE MANAGE_DB;
USE SCHEMA external_stages;



// Creating external stage

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3'
    credentials=(aws_key_id='ABCD_DUMMY_ID' aws_secret_key='1234abcd_key');

// Description of external stage

DESC STAGE MANAGE_DB.external_stages.aws_stage; 
    
    
// Alter external stage   

ALTER STAGE aws_stage
    SET credentials=(aws_key_id='XYZ_DUMMY_ID' aws_secret_key='987xyz');
    
    
// Publicly accessible staging area    

CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

// List files in stage

LIST @aws_stage;

// Creating ORDERS table

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.ORDERS;

// List files contained in stage

LIST @MANAGE_DB.external_stages.aws_stage;  
   
// First copy command
// ERROR Will be raised as there are 3 files in the stage location
// and the files have different schema

-- COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
--     FROM @aws_stage
--     file_format = (type = csv field_delimiter=',' skip_header=1);

// Copy command with fully qualified stage object

-- COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
--     FROM @MANAGE_DB.external_stages.aws_stage
--     file_format= (type = csv field_delimiter=',' skip_header=1);

  
// Copy command with specified file(s)

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails.csv');
    
// Copy command with pattern for file names

COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';
// this would result in 0 rows being added
// because snowflake keeps the track of the metadata and the files that have been loaded

select count(*) from OUR_FIRST_DB.PUBLIC.ORDERS;





CREATE OR REPLACE DATABASE EXERCISE_DB;
USE DATABASE EXERCISE_DB;
CREATE OR REPLACE TABLE "EXERCISE_DB"."PUBLIC"."CUSTOMERS" 
("ID" INTEGER,
"first_name" VARCHAR,
"last_name" VARCHAR,
"email" VARCHAR,
"age" INTEGER,
"CITY" VARCHAR);



CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_loading_data
    url='s3://snowflake-assignments-mc/gettingstarted/'

List @MANAGE_DB.external_stages.aws_loading_data;

COPY INTO EXERCISE_DB.PUBLIC.CUSTOMERS
FROM @MANAGE_DB.external_stages.aws_loading_data
file_format= (type = csv field_delimiter=',' skip_header=1)
files = ('customers.csv');

select * from EXERCISE_DB.PUBLIC.CUSTOMERS;



