// Information Schema
/*
 The Snowflake Information Schema contains of a set of system-defined views and table functions that provide extensive metadata information about the objects created in your account. 
 The Information Schema is implemented as a schema named INFORMATION_SCHEMA that is automatically created when you create a Database.
 INFORMATION_SCHEMA contains following objects:
Views for all the objects contained in the database
Views for account-level objects (i.e. non-database objects such as roles and warehouses)
Table functions for account level usage and historical information.
 Go through below documentation for complete details on INFORMATION_SCHEMA views and functions.

*/

/*
Important Views:
1. TABLES: Gives complete details about the tables present in all the schemas of that Database.
The details include TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_OWNER, TABLE_TYPE, CLUSTERING_KEY, ROW_COUNT, BYTES, RETENTION_TIME, CREATED, LAST_ALTERED, COMMENT etc.
2. VIEWS: Gives complete details about the views present in all the schemas of that Database.
The details include TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, TABLE_OWNER, VIEW_DEFINITION, IS_SECURED, CREATED, LAST_ALTERED, COMMENT etc.
3. COLUMNS: Gives complete details of the columns present in all the tables of that Database.
The details include TABLE_CATALOG, TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE, LENGTH, COLUMN_DEFAULT, COMMENT etc.
*/

// INFORMATION_SCHEMA
/*
Other important Views:
 FUNCTIONS
 PROCEDURES
 PIPES
 LOAD_HISTORY
 EXTERNAL_TABLES
 FILE_FORMATS
 STAGES
 TABLE_CONSTRAINTS
 TABLE_PRIVILEGES

 The table functions in INFORMATION_SCHEMA can be used to return account-level usage and historical information for storage, warehouses, user logins, and queries:
Below are some of the important table functions.
 COPY_HISTORY
 DYNAMIC_TABLES
 DATABASE_REFRESH_HISTORY
 NOTIFICATION_HISTORY
 PIPE_USAGE_HISTORY
 SERVERLESS_TASK_HISTORY
 TASK_HISTORY
 VALIDATE_PIPELOAD
 WAREHOUSE_LOAD_HISTORY

*/
