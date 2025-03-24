// Table Literals
/*
Some times we may need to use variables and parameters as Table names, that time these Table literals are useful.
Syntax: TABLE(  <string_literal> | <session_variable> | <bind_variable>  )
      where, string_literal – Table name or Fully Qualified Table name
Table literals are used to pass the name of a table or a placeholder value (instead of a table name) to a query. 
Table literals appear in the FROM clause of a SQL statement and consist of either the table name, or a SQL variable. 
We can think of Table Literals as like a table function TABLE() 
Table Literals,
Accepts a scalar value as input.
Returns a set of 0 or more rows.
Can be used as a source of rows in a FROM clause.
*/

/*

Examples:
SELECT * FROM TABLE('table_name');
SELECT * FROM TABLE('db_name.schema_name.table_name');
SET myvar = 'mytable';
SELECT * FROM TABLE($myvar);
SELECT * FROM TABLE(?);
SELECT * FROM TABLE(:bind_variable);
Below are wrong.
SELECT * FROM $myvar;
SELECT * FROM ?;
SELECT * FROM :bind_variable;


*/


// Identifiers
/*
In Snowflake if we need to refer any objects by using string literals, variables, session variables or bind variables, we use Identifiers.
Using Table literals we can just refer to Tables but if we need to refer other objects like Database, Schema or Function along with Tables we use Identifiers.
Tables literals can be used only in From clause, but we can use Identifiers in any type of statement.
Syntax: IDENTIFIER(  <string_literal> | <session_variable> | <bind_variable> | <SQL Variable> )
Examples:
    create or replace database identifier('my_db');
    set schema_name = 'my_db.my_schema';
    use schema identifier($schema_name);
    use schema identifier(?);
    drop table identifier(?);
    describe table identifier(:table_name)
    select count(*) as count from identifier(:table_name)
*/

SET DB = 'EMP';
SET TBL_SCHEMA = 'HRDATA';
SET SPROCS_SCHEMA = 'SPROCS';

USE DATABASE IDENTIFIER($DB);
USE SCHEMA IDENTIFIER($TBL_SCHEMA);

CREATE SCHEMA IF NOT EXISTS IDENTIFIER($SPROCS_SCHEMA);
CREATE SCHEMA IF NOT EXISTS IDENTIFIER($TBL_SCHEMA);

CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_LITERALS_IDENTIFIERS("DBNAME" VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
COMMENT = 'This SP is to understand table literals and indentifers'
EXECUTE AS CALLER
AS

DECLARE
    tab1 VARCHAR;
    tab2 VARCHAR DEFAULT 'departments';
    dept INTEGER;
    empl INTEGER;
    cntry INTEGER;
    loc INTEGER;

BEGIN
    tab1 := 'employees';
    LET tab3 := 'countries';
    
    USE DATABASE IDENTIFIER(:DBNAME);
    USE SCHEMA IDENTIFIER($TBL_SCHEMA);

    SELECT COUNT(*) INTO :empl FROM TABLE(:tab1);
    SELECT COUNT(*) INTO :dept FROM IDENTIFIER(:tab2);
    SELECT COUNT(*) INTO :cntry FROM TABLE(:tab3);
    SELECT COUNT(*) INTO :loc FROM IDENTIFIER('EMP.HRDATA.locations');

    RETURN 'Employee Count:'||empl||' Department Count:'||dept||' Country Count:'||cntry||' Location Count:'||loc;
END;

CALL EMP.SPROCS.SP_LITERALS_IDENTIFIERS('EMP');