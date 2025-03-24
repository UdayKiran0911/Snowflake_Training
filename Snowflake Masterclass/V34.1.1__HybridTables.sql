-- HYBRID TABLES
    -- A hybrid table is a Snowflake table type that is optimized for hybrid transactional and operational workloads that require low latency and high throughput on small random point reads and writes. 
    -- A hybrid table supports unique and referential integrity constraint enforcement that is critical for transactional workloads. 
    -- You can use a hybrid table along with other Snowflake tables and features to power Unistore workloads that bring transactional and analytical data together in a single platform.
    -- Hybrid tables leverage a row store as the primary data store to provide excellent operational query performance. 
    -- When you write to a hybrid table, the data is written directly into the row store. 
    -- Data is asynchronously copied into object storage in order to provide better performance and workload isolation for large scans without affecting your ongoing operational workloads. 
    -- Some data may also be cached in columnar format on your warehouse in order to provide better performance on analytical queries.
    -- Hybrid tables support critical transactional features like, Primary Keys, Foreign Keys, Unique constraints and indexes


-- Limitations
    -- Clouds and regions
        -- Hybrid tables are available in all commercial Amazon Web Services (AWS) regions.
        -- Hybrid tables are not available in Azure or Google Cloud Platform (GCP).
        -- Hybrid tables are not available in U.S. SnowGov Regions.
        -- Hybrid tables are not supported in trial accounts.
        -- If you are a Virtual Private Snowflake (VPS) customer, contact Snowflake Support to inquire about enabling hybrid tables for your account.
    -- Clustering keys
        -- Clustering keys are not supported in hybrid tables. 
        -- Data in hybrid tables is ordered by primary key.
    -- Constraints
        -- PRIMARY KEY, UNIQUE, and FOREIGN KEY constraints are enforced for hybrid tables
    -- COPY
        -- When you load a hybrid table with the COPY INTO command, ABORT_STATEMENT is the only option that is supported for ON_ERROR. 
        -- Setting ON_ERROR=SKIP_FILE returns an error.
    -- Data size
        -- You are limited to storing 2 TB of data in hybrid tables per Snowflake database
    -- Native applications
        -- You can include hybrid tables in a Snowflake Native App. 
        -- However, hybrid tables cannot be shared from the provider to the consumer. 
        -- Native Apps can create hybrid tables in the consumer account, and they can read from and write to those hybrid tables. 
        -- You can also expose hybrid tables to application roles so that they can be queried directly by consumer users.
        -- You cannot create a hybrid table in a provider account, nor can you include that hybrid table in a view that is shared through the Native App.
    -- Optimized bulk loading
        -- When a hybrid table is empty, CTAS, COPY, and INSERT INTO … SELECT all use optimized bulk loading. 
        -- When hybrid tables are not empty, optimized bulk loading is not used.
    -- Persisted query results
        -- Queries against hybrid tables do not use the results cache, as defined with the USE_CACHED_RESULT parameter.
    -- Replication
        -- Replication of hybrid tables is currently not supported.
    -- Time Travel and cloning
        -- Time Travel queries that select from hybrid tables are supported with the following limitations:
        -- Only the TIMESTAMP parameter is supported in the AT clause.
            -- The value of the TIMESTAMP parameter must be the same for all tables that belong to the same database.
            -- If the tables belong to different databases, you can use different TIMESTAMP values.
        -- The OFFSET, STATEMENT, and STREAM parameters are not supported.
        -- The BEFORE clause is not supported.
        -- The UNDROP TABLE command, which depends on Time Travel, is not supported.
    -- Transactions
        -- For hybrid tables, the transaction scope is the database in which the hybrid table resides. 
        -- All the hybrid tables referenced in a transaction must reside in the same database
    -- Transient schemas and databases
        -- You cannot create hybrid tables that are temporary or transient. 
        -- In turn, you cannot create hybrid tables within transient schemas or databases.
    -- UNDROP
        -- UNDROP is not supported for hybrid tables. Additionally:
            -- UNDROP SCHEMA and UNDROP DATABASE commands succeed for entities that contain hybrid tables, but those hybrid tables and their associated constraints and indexes cannot be restored.
            -- The DELETED column in TABLES view displays the time of deletion as the UNDROP time of the parent entity.
            -- ACCESS_HISTORY view contains an entry for DROP/UNDROP of the parent entity, but no entries for hybrid tables.


CREATE OR REPLACE DATABASE HYBRID_DB;
USE DATABASE HYBRID_DB;

CREATE OR REPLACE SCHEMA HYBRID_SCM;
USE SCHEMA HYBRID_SCM;

USE WAREHOUSE COMPUTE_WH;

CREATE OR REPLACE HYBRID TABLE icecream (
  id NUMBER PRIMARY KEY AUTOINCREMENT START 1 INCREMENT 1,
  col1 VARCHAR NOT NULL,
  col2 VARCHAR NOT NULL
  );

INSERT INTO icecream VALUES(1, 'A1', 'B1');
INSERT INTO icecream VALUES(2, 'A2', 'B2');
INSERT INTO icecream VALUES(3, 'A3', 'B3');
INSERT INTO icecream VALUES(4, 'A4', 'B4');

UPDATE icecream SET col2 = 'B3-updated' WHERE id = 3;

DELETE FROM icecream WHERE id = 4;

SELECT * FROM icecream;


