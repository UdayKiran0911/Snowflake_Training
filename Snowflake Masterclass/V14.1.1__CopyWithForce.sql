---- FORCE ----

USE DATABASE COPY_DB;

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
    pattern='.*Order.*';

// Not possible to load file that have been loaded and data has not been modified
COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*';
   

SELECT * FROM ORDERS;    


// Using the FORCE option

COPY INTO COPY_DB.PUBLIC.ORDERS
    FROM @aws_stage_copy
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*Order.*'
    FORCE = TRUE;

SELECT count(*) from COPY_DB.PUBLIC.ORDERS;




CREATE OR REPLACE TABLE  COPY_DB.PUBLIC.employees (
    customer_id int,
    first_name varchar(50),
    last_name varchar(50),
    email varchar(50),
    age int,
    department varchar(50));


CREATE or REPLACE STAGE COPY_DB.PUBLIC.emp_assign_stg
    URL = 's3://snowflake-assignments-mc/copyoptions/example2';

list @COPY_DB.PUBLIC.emp_assign_stg;

CREATE or REPLACE FILE FORMAT COPY_DB.PUBLIC.emp_assign_ff
    TYPE = CSV
    FIELD_DELIMITER=','
    SKIP_HEADER=1;

COPY INTO COPY_DB.PUBLIC.employees
    FROM @COPY_DB.PUBLIC.emp_assign_stg
    file_format= (FORMAT_NAME = COPY_DB.PUBLIC.emp_assign_ff)
    pattern='.*employees.*'
    VALIDATION_MODE = RETURN_ERRORS;

COPY INTO COPY_DB.PUBLIC.employees
    FROM @COPY_DB.PUBLIC.emp_assign_stg
    file_format= (FORMAT_NAME = COPY_DB.PUBLIC.emp_assign_ff)
    pattern='.*employees.*'
    TRUNCATECOLUMNS = true;