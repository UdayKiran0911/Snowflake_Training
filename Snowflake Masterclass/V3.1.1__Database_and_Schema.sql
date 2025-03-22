use role sysadmin;

create or replace database first_db;
create or replace schema first_sc; -- schema helps in maintaining metadata of the database objects

use database FIRST_DB;
use schema first_sc;

-- altering database name
ALTER DATABASE FIRST_DB RENAME TO OUR_FIRST_DB;


-- granting roles and previlages?
