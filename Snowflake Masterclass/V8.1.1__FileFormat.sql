USE ROLE SYSADMIN;
USE WAREHOUSE FIRST_WAREHOUSE;
// Database to manage stage objects, fileformats etc.
CREATE OR REPLACE DATABASE MANAGE_DB;
CREATE OR REPLACE SCHEMA external_stages;
USE DATABASE MANAGE_DB;
USE SCHEMA external_stages;

 CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage_errorex
    url='s3://bucketsnowflakes4';


// Specifying file_format in Copy command
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (type = csv field_delimiter=',' skip_header=1)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 
    
    

// Creating table
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.ORDERS_EX (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30));    
    
// Creating schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;

// See properties of file format object
DESC file format MANAGE_DB.file_formats.my_file_format;


// Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


// Altering file format object
ALTER file format MANAGE_DB.file_formats.my_file_format
    SET SKIP_HEADER = 1;

DESC file format MANAGE_DB.file_formats.my_file_format;
    
// Defining properties on creation of file format object   
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format
    TYPE=JSON,
    TIME_FORMAT=AUTO;    
    
// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   

  
// Using file format object in Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM @MANAGE_DB.external_stages.aws_stage_errorex
    file_format= (FORMAT_NAME=MANAGE_DB.file_formats.my_file_format)
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


// Altering the type of a file format is not possible
ALTER file format MANAGE_DB.file_formats.my_file_format
SET TYPE = CSV;
// will raise an error: File format type cannot be changed.
// because every file type or format have different properties attached to it.


// Recreate file format (default = CSV)
CREATE OR REPLACE file format MANAGE_DB.file_formats.my_file_format;


// See properties of file format object    
DESC file format MANAGE_DB.file_formats.my_file_format;   



// Truncate table
TRUNCATE table OUR_FIRST_DB.PUBLIC.ORDERS_EX;



// Overwriting properties of file format object      
COPY INTO OUR_FIRST_DB.PUBLIC.ORDERS_EX
    FROM  @MANAGE_DB.external_stages.aws_stage_errorex
    file_format = (FORMAT_NAME= MANAGE_DB.file_formats.my_file_format  field_delimiter = ',' skip_header=1 )
    files = ('OrderDetails_error.csv')
    ON_ERROR = 'SKIP_FILE_3'; 

DESC STAGE MANAGE_DB.external_stages.aws_stage_errorex;



USE DATABASE EXERCISE_DB;

CREATE OR REPLACE SCHEMA file_formats;

create or replace table EXERCISE_DB.file_formats.customer
(
"ID" INT,
"first_name" varchar,
"last_name" varchar,
"email" varchar,
"age" int,
"city" varchar
);

CREATE OR REPLACE STAGE EXERCISE_DB.file_formats.excerise_stg
    URL = 's3://snowflake-assignments-mc/fileformat/';


CREATE OR REPLACE FILE FORMAT EXERCISE_DB.file_formats.my_file_format
    SKIP_HEADER = 1
    TYPE = CSV
    FIELD_DELIMITER=',';

list @EXERCISE_DB.file_formats.excerise_stg;

COPY INTO EXERCISE_DB.file_formats.customer
    FROM  @EXERCISE_DB.file_formats.excerise_stg
    file_format = (FORMAT_NAME=EXERCISE_DB.file_formats.my_file_format)
    files = ('customers4.csv')
    ON_ERROR = 'SKIP_FILE_3'; 


