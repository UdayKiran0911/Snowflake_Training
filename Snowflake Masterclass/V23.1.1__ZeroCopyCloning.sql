// ZERO COPY CLONING
-- Databases, Scehmas, Tables, Streams, File Formats, Sequences, Tasks can be cloned
-- Pipes and Stages can also be cloned, however
    -- Pipes can only be cloned if it is referening an extrernal stages
    -- Named internal stages can not be cloned
-- When a database or schema is cloned, all the child objects will be cloned as well, with some exceptions for Pipes and Stages
-- Cloning is a metadata operations and no data is being actually copied and take the snapshot of the main table, this operation do not cost any data storage cost
-- Modification to the original table will have no effect on the clone
-- Clone object is independent object
-- When a clone is created for database, all the objects in the database will inherit the privilages, but not the database, same is with the schema all the objects in the schema will inherit the privilages, but not the schema itself. Privilages for database and schema had to be set by the admin.

-- Privilages required for cloning
-- Table: SELECT Privilage
-- Pipes, Streams, Tasks: OWNER Privilage
-- All other objects: USAGE Privilage

-- Considerations: Load history metadata is not copied, meaning if the main table is restored to its previous state, the clone will not be effected

-- a temporary table can not be cloned into permanent or tansient table


// Cloning

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS;

CREATE TABLE OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE
CLONE OUR_FIRST_DB.PUBLIC.CUSTOMERS;


// Validate the data
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE;


// Update cloned table

UPDATE OUR_FIRST_DB.public.CUSTOMERS_CLONE
SET LAST_NAME = NULL;

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS ;

SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS_CLONE;

// Cloning a temporary table is not possible
CREATE OR REPLACE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TEMP_TABLE(
  id int);

CREATE TEMPORARY TABLE OUR_FIRST_DB.PUBLIC.TABLE_COPY
CLONE OUR_FIRST_DB.PUBLIC.TEMP_TABLE;

SELECT * FROM OUR_FIRST_DB.PUBLIC.TABLE_COPY;




// Cloning Schema
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
CLONE OUR_FIRST_DB.PUBLIC;

SELECT * FROM COPIED_SCHEMA.CUSTOMERS;

CREATE TRANSIENT SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED
CLONE MANAGE_DB.EXTERNAL_STAGES;

// Cloning Database
CREATE TRANSIENT DATABASE OUR_FIRST_DB_COPY
CLONE OUR_FIRST_DB;

DROP DATABASE OUR_FIRST_DB_COPY;
DROP SCHEMA OUR_FIRST_DB.EXTERNAL_STAGES_COPIED;
DROP SCHEMA OUR_FIRST_DB.COPIED_SCHEMA;





// Cloning using time travel
// Setting up table

CREATE OR REPLACE TABLE OUR_FIRST_DB.public.time_travel (
   id int,
   first_name string,
  last_name string,
  email string,
  gender string,
  Job string,
  Phone string);
    
CREATE OR REPLACE FILE FORMAT MANAGE_DB.file_formats.csv_file
    type = csv
    field_delimiter = ','
    skip_header = 1;
    
CREATE OR REPLACE STAGE MANAGE_DB.external_stages.time_travel_stage
    URL = 's3://data-snowflake-fundamentals/time-travel/'
    file_format = MANAGE_DB.file_formats.csv_file;
    
LIST @MANAGE_DB.external_stages.time_travel_stage;

COPY INTO OUR_FIRST_DB.public.time_travel
from @MANAGE_DB.external_stages.time_travel_stage
files = ('customers.csv');

SELECT * FROM OUR_FIRST_DB.public.time_travel;

// Update data 
UPDATE OUR_FIRST_DB.public.time_travel
SET FIRST_NAME = 'Frank' ;


// Using time travel
SELECT * FROM OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1);

// Using time travel
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone
CLONE OUR_FIRST_DB.public.time_travel at (OFFSET => -60*1.5);

SELECT * FROM OUR_FIRST_DB.PUBLIC.time_travel_clone;

// Update data again
UPDATE OUR_FIRST_DB.public.time_travel_clone
SET JOB = 'Snowflake Analyst' ;

// Using time travel: Method 2 - before Query
SELECT * FROM OUR_FIRST_DB.public.time_travel_clone before (statement => '<your-query-id>');

CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.time_travel_clone_of_clone
CLONE OUR_FIRST_DB.public.time_travel_clone before (statement => '<your-query-id>');

SELECT * FROM OUR_FIRST_DB.public.time_travel_clone_of_clone ;







//// Swapping tables
// Setting up dev table
CREATE TRANSIENT SCHEMA OUR_FIRST_DB.COPIED_SCHEMA
CLONE OUR_FIRST_DB.PUBLIC;

SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS

// Modifying "Dev Table"
DELETE FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS WHERE ID < 500

SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS


// Swapping Tables
ALTER TABLE OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS
SWAP WITH OUR_FIRST_DB.PUBLIC.CUSTOMERS

// Verifying results
SELECT * FROM OUR_FIRST_DB.COPIED_SCHEMA.CUSTOMERS
SELECT * FROM OUR_FIRST_DB.PUBLIC.CUSTOMERS
