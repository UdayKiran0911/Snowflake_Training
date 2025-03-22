SELECT * FROM SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER;
-- SNOWFLAKE_SAMPLE_DATA.TPCH_SF1.CUSTOMER is know as fully qualified table name, where a table is accessed using <database.schema.table_name>


-- To be able to create the virtual warehouse, 
-- you have to use at least the role SYSADMIN (or SECURITYADMIN or ACCOUNTADMIN)
USE ROLE SYSADMIN;

-- Creating a warehouse using query
CREATE OR REPLACE WAREHOUSE SECOND_WH
WITH
WAREHOUSE_SIZE = XSMALL
INITIALLY_SUSPENDED = FALSE
MIN_CLUSTER_COUNT = 1
MAX_CLUSTER_COUNT = 3
SCALING_POLICY = 'STANDARD'
AUTO_SUSPEND = 300
AUTO_RESUME = FALSE
COMMENT = 'This is the second warehouse';

-- resuming or suspending a warehouse
ALTER WAREHOUSE SECOND_WH RESUME;
ALTER WAREHOUSE SECOND_WH SUSPEND;

-- Altering the warehouse
ALTER WAREHOUSE SECOND_WH SET WAREHOUSE_SIZE = 'SMALL';

-- Droping a warehouse
DROP WAREHOUSE SECOND_WH;

-- Transfering the ownership?
