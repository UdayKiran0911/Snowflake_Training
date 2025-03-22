//Rename data base & creating the table + meta data

USE ROLE SYSADMIN;
USE WAREHOUSE FIRST_WAREHOUSE;
USE DATABASE OUR_FIRST_DB;
USE SCHEMA FIRST_SC;

CREATE TABLE "OUR_FIRST_DB"."PUBLIC"."LOAN_PAYMENT" (
  "Loan_ID" STRING,
  "loan_status" STRING,
  "Principal" STRING,
  "terms" STRING,
  "effective_date" STRING,
  "due_date" STRING,
  "paid_off_time" STRING,
  "past_due_days" STRING,
  "age" STRING,
  "education" STRING,
  "Gender" STRING);
  
  
 //Check that table is empty

 SELECT * FROM LOAN_PAYMENT;

 
 //Loading the data from S3 bucket
  
 COPY INTO LOAN_PAYMENT
    FROM s3://bucketsnowflakes3/Loan_payments_data.csv
    file_format = (type = csv 
                   field_delimiter = ',' 
                   skip_header=1);
    

//Validate
 SELECT * FROM LOAN_PAYMENT;



CREATE OR REPLACE DATABASE EXERCISE_DB;
USE DATABASE EXERCISE_DB;
CREATE TABLE "EXERCISE_DB"."PUBLIC"."CUSTOMERS" (
"ID" INT,
"first_name" varchar,
"last_name" varchar,
"email" varchar,
"age" int,
"city" varchar);


//Check that table is empty

SELECT * FROM EXERCISE_DB.PUBLIC.CUSTOMERS;


//Loading the data from S3 bucket

COPY INTO CUSTOMERS
    FROM s3://snowflake-assignments-mc/gettingstarted/customers.csv
        file_format = (type = csv 
                       field_delimiter = ',' 
                       skip_header=1);


//Validate
SELECT * FROM CUSTOMERS;