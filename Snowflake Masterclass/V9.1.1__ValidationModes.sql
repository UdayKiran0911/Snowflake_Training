---- VALIDATION_MODE ----
// Prepare database & table
CREATE OR REPLACE DATABASE COPY_DB;


CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT VARCHAR(30),
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));

// Prepare stage object
CREATE OR REPLACE STAGE COPY_DB.PUBLIC.aws_stage_copy
    url='s3://snowflakebucket-copyoption/size/';
  
LIST @COPY_DB.PUBLIC.aws_stage_copy;
  
    
 //Load data using copy command
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    VALIDATION_MODE = RETURN_ERRORS;
    
SELECT * FROM ORDERS;    
    
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
   VALIDATION_MODE = RETURN_5_ROWS ;



--- Use files with errors ---

create or replace stage copy_db.public.aws_stage_copy
    url ='s3://snowflakebucket-copyoption/returnfailed/';
    
list @copy_db.public.aws_stage_copy;

-- show all errors --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    validation_mode=return_errors;

-- validate first n rows --
copy into copy_db.public.orders
    from @copy_db.public.aws_stage_copy
    file_format = (type=csv field_delimiter=',' skip_header=1)
    pattern='.*error.*'
    validation_mode=return_1_rows;



create or replace table copy_db.public.employees (
customer_id int,
  first_name varchar(50),
  last_name varchar(50),
  email varchar(50),
  age int,
  department varchar(50)
);

create or replace stage copy_db.public.validation_mode_stg
    url = 's3://snowflake-assignments-mc/copyoptions/example1';

list @copy_db.public.validation_mode_stg;

create or replace file format copy_db.public.validation_mode_ff
    TYPE = CSV
    FIELD_DELIMITER=','
    SKIP_HEADER=1;

desc file format copy_db.public.validation_mode_ff;

USE DATABASE copy_db;

-- copy into copy_db.public.employees
--     from @copy_db.public.validation_mode_stg
--     file_format = (FORMAT_NAME = copy_db.public.validation_mode_ff)
--     //pattern='.*employees.*'
--     validation_mode=return_errors;

copy into copy_db.public.employees
    from @copy_db.public.validation_mode_stg
    file_format = (FORMAT_NAME = copy_db.public.validation_mode_ff)
    //pattern='.*employees.*'
    on_error='continue';
    