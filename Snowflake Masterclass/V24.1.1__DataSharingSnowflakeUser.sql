//Data Sharing
-- in Snowflake storage is decupled fron compute, this makes sharing data easy
    -- Sharing with actually copying data
    -- data is always up-to-date
    -- Compute cost paid by the consumer

-- Provider account >>>> Consumer account (read only access)
-- Data sharing is managed at cloud service layer

-- Steps
    -- Create Share: 'Accountadmin' role or CREATE SHARE privilage required
    -- Grant privilages: 
        -- DB, Schema, Tables
    -- Consumer account: ALTER SHARE <share_name> ADD ACCOUNT <account>;
    -- Import Share: 'Accountadmin' role or IMPORT SHARE / CREATE DATABASE privilage required

-- What can be shared?
    -- Tables, External Tables, Secure Views, Secure materialized views, Secure UDFs
    -- best practice would be to share the secure views

CREATE OR REPLACE DATABASE DATA_S;


CREATE OR REPLACE STAGE MANAGE_DB.external_stages.aws_stage
    url='s3://bucketsnowflakes3';

// List files in stage
LIST @aws_stage;

// Create table
CREATE OR REPLACE TABLE DATA_S.PUBLIC.ORDERS (
ORDER_ID	VARCHAR(30)
,AMOUNT	NUMBER(38,0)
,PROFIT	NUMBER(38,0)
,QUANTITY	NUMBER(38,0)
,CATEGORY	VARCHAR(30)
,SUBCATEGORY	VARCHAR(30));


// Load data using copy command
COPY INTO DATA_S.PUBLIC.ORDERS
    FROM @MANAGE_DB.external_stages.aws_stage
    file_format= (type = csv field_delimiter=',' skip_header=1)
    pattern='.*OrderDetails.*';
    
SELECT * FROM ORDERS;


// Create a share object
CREATE OR REPLACE SHARE ORDERS_SHARE;

---- Setup Grants ----

// Grant usage on database
GRANT USAGE ON DATABASE DATA_S TO SHARE ORDERS_SHARE; 

// Grant usage on schema
GRANT USAGE ON SCHEMA DATA_S.PUBLIC TO SHARE ORDERS_SHARE; 

// Grant SELECT on table
GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE ORDERS_SHARE; 

// Validate Grants
SHOW GRANTS TO SHARE ORDERS_SHARE;


---- Add Consumer Account ----
ALTER SHARE ORDERS_SHARE ADD ACCOUNT=GVRBQXJ;
