/*
A stored procedure is a set of statements(SQL queries) executed in some order. 
These statements can be Insert, Delete, Update, Select. 
We write stored procedures
1. When there is a need to run set of SQL statements together.
2. Dynamically prepare and execute SQL statements based on the parameters given.
3. When there is a need to run SQL statements based on some conditions.
4. When there is a need to run one or more SQL statements in loop.  
Note: In most of the databases we can write procedures using SQL only. 
But in Snowflake we have a flexibility of writing procedures using JavaScript, Scala, Java, Python along with SQL.
** But the procedures written using SQL is called as Snowflake Scripting.
*/

//Blocks in Stored Procedure

/*
-- Create Section
CREATE OR REPLACE PROCEDURE PROCEDURE_NAME(Param1 Datatype, Param2 Datatype, … )
    RETURNS      < Datatype or Table(columns)>
    LANGUAGE   < SQL or JavaScript or Scala or Python >
    COMMENT =  ‘< May be Description of the Program >’
    EXECUTE AS  < Caller or Owner >
AS

-- Declare Section
DECLARE
    cust_id INTEGER;
    name VARCHAR(50),
    comments STRING;
    dob DATE;
    cur1 CURSOR FOR SQL_STATEMENT;
    res RESULTSET;
    exc1 EXCEPTION(..);

-- Body Section
BEGIN    
      SQL Statements
      Arithmetic Operations
      String Operations
      Branching Statements
      Looping Statements
END;

-- Exception Section
EXCEPTION
   WHEN STATEMENT ERROR THEN
        Action;  -- Return (or) any SQL Statement
   WHEN exc1 THEN
        Action;  -- Return (or) any SQL Statement
   WHEN OTHER ERROR THEN
        Action;  -- Return (or) any SQL Statement
END;



-- Executing or Running or Calling a Procedure:
CALL PROCEDURE_NAME(Parameters);
-- In some databases: EXEC PROCEDURE_NAME(Parameters);
-- Dropping a Procedure:
DROP PROCEDURE_NAME(Parameters);
*/
