// Exception Handling

/*
In Snowflake Scripting, an exception occurs when an error happens while executing a statement.
Snowflake Scripting raises an exception when it encounters any error while executing a statement
An exception prevents the next lines of code from executing.
We can handle exceptions that occur in the procedure using handlers.
When an exception is raised in a Snowflake Scripting block (either by your code or by a sql statement that fails to execute), Snowflake Scripting attempts to find a handler for that exception, based on the handler it performs certain action.
We can define and raise our own exception as well.
We can declare exceptions in declaration section using below statement 
    DECLARE exception_name EXCEPTION (error_code, ‘error message’); 
    Here, error code should be between -20999 to -20001


We can define handlers in the Exceptions block of a procedure.
Currently, Snowflake provides the following built-in exceptions.
    STATEMENT_ERROR: This exception indicates an error while executing a statement. For example, if you attempt to drop
    table that does not exist, this exception is raised.
    EXPRESSION_ERROR: This exception indicates an error related to an expression. For example, if you create an expression
    that evaluates to a VARCHAR, and you attempt to assign the value of the expression to a FLOAT, this error is raised.
Handler gives below 3 details about the exception.
SQLCODE: This is a 5-digit signed integer. For user-defined exceptions, we can give our choice of error code that is between -20999 to -20001
SQLERRM: This is an error message. For user-defined exceptions, we can give our own message that is related to the error we are handling.
SQLSTATE: This is a 5-character code modeled on the ANSI SQL standard SQLSTATE.
*/

/*
DECLARE   
         my_exception EXCEPTION (-20002, 'Raised MY_EXCEPTION');
BEGIN
  < Code >
END;
EXCEPTION 
WHEN statement_error THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT ERROR’, 'SQLCODE', sqlcode, 'SQLERRM', sqlerrm, 'SQLSTATE', sqlstate);
WHEN expression_error THEN  
    RETURN OBJECT_CONSTRUCT('Error type', 'EXPRESSION ERROR’,'SQLCODE', sqlcode, 'SQLERRM', sqlerrm, 'SQLSTATE', sqlstate);
WHEN my_exception THEN
    RETURN OBJECT_CONSTRUCT('Error type', 'MY_EXCEPTION’, 'SQLCODE', sqlcode, 'SQLERRM', sqlerrm, 'SQLSTATE', sqlstate);
WHEN OTHER THEN
    RETURN OBJECT_CONSTRUCT('Error type', ‘OTHER ERROR’, 'SQLCODE', sqlcode, 'SQLERRM', sqlerrm,  'SQLSTATE', sqlstate);
END;
*/

-- Demo program to handle exceptions
-- Get the number of employees working in the given Country, return if any errors
CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_EXCEPTION_HANDLING_DEMO("COUNTRY" VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    no_data_found EXCEPTION (-20101, 'No Data Found in Employee Table');
    cnt INTEGER;
    loc_emp_count INTEGER;
    lec DATE;
    
BEGIN
SELECT COUNT(*) into :cnt FROM hrdata.employees;

IF(:cnt = 0) THEN
	RAISE no_data_found;
END IF;

SELECT COUNT(*) into :loc_emp_count FROM hrdata.employees e
JOIN hrdata.departments d ON e.dept_id = d.dept_id
JOIN hrdata.locations l ON l.location_id = d.location_id
WHERE UPPER(l.country_id) = :COUNTRY;

--lec := loc_emp_count;

RETURN 'Number of Employees working in '||COUNTRY||' is: '||loc_emp_count;
--RETURN 'Number of Employees working in '||COUNTRY||' is: '||lec;

EXCEPTION 
WHEN statement_error THEN
RETURN OBJECT_CONSTRUCT('Error type', 'STATEMENT ERROR',
						'SQLCODE', sqlcode,
						'SQLERRM', sqlerrm,
						'SQLSTATE', sqlstate);
						
WHEN expression_error THEN 
RETURN OBJECT_CONSTRUCT('Error type', 'EXPRESSION ERROR',
						'SQLCODE', sqlcode,
						'SQLERRM', sqlerrm,
						'SQLSTATE', sqlstate); 

WHEN no_data_found THEN
RETURN OBJECT_CONSTRUCT('Error type', 'USER-DEFINED EXCEPTION',
						'SQLCODE', sqlcode,
						'SQLERRM', sqlerrm,
						'SQLSTATE', sqlstate);
END;


CALL EMP.SPROCS.SP_EXCEPTION_HANDLING_DEMO('US');
CALL EMP.SPROCS.SP_EXCEPTION_HANDLING_DEMO('UK'); 

============================================
-- Inserting the errors into a log table
CREATE SCHEMA IF NOT EXISTS EMP.WORK;

CREATE OR REPLACE TABLE EMP.WORK.SP_ERROR_LOGS
(PROC_NAME VARCHAR, ERROR_TYPE VARCHAR, ERROR_CODE VARCHAR, ERROR_MESSAGE VARCHAR, SQL_STATE VARCHAR, LOAD_TIME TIMESTAMP);

-- Get the number of employees working in the given Country, log if any error into a log table
CREATE OR REPLACE PROCEDURE EMP.PROCS.SP_ERROR_LOGGING_DEMO("COUNTRY" VARCHAR)
RETURNS INTEGER
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    no_data_found EXCEPTION (-20101, 'No Data Found in Employee Table');
    cnt INTEGER;
    loc_emp_count INTEGER;
    lec DATE;
    
BEGIN
SELECT COUNT(*) into :cnt FROM hrdata.employees;

IF(:cnt = 0) THEN
	RAISE no_data_found;
END IF;

SELECT COUNT(*) into :loc_emp_count FROM hrdata.employees e
JOIN hrdata.departments d ON e.dept_id = d.dept_id
JOIN hrdata.locations l ON l.location_id = d.location_id
WHERE UPPER(l.country_id) = :COUNTRY;

--lec := loc_emp_count;

RETURN 'Number of Employees working in '||COUNTRY||' is: '||loc_emp_count;
--RETURN 'Number of Employees working in '||COUNTRY||' is: '||lec;

EXCEPTION 
WHEN statement_error THEN
	INSERT INTO WORK.SP_ERROR_LOGS (PROC_NAME, ERROR_TYPE, ERROR_CODE, ERROR_MESSAGE, SQL_STATE, LOAD_TIME)
	VALUES ('SP_ERROR_LOGGING_DEMO', 'STATEMENT ERROR', :SQLCODE, :SQLERRM, :SQLSTATE, SYSDATE());
	
WHEN expression_error THEN
	INSERT INTO WORK.SP_ERROR_LOGS (PROC_NAME, ERROR_TYPE, ERROR_CODE, ERROR_MESSAGE, SQL_STATE, LOAD_TIME)
	VALUES ('SP_ERROR_LOGGING_DEMO', 'EXPRESSION ERROR', :SQLCODE, :SQLERRM, :SQLSTATE, SYSDATE());

WHEN no_data_found THEN
	INSERT INTO WORK.SP_ERROR_LOGS (PROC_NAME, ERROR_TYPE, ERROR_CODE, ERROR_MESSAGE, SQL_STATE, LOAD_TIME)
	VALUES ('SP_ERROR_LOGGING_DEMO', 'USER DEFINED EXCEPTION', :SQLCODE, :SQLERRM, :SQLSTATE, SYSDATE());
END;


CALL EMP.PROCS.SP_ERROR_LOGGING_DEMO('US');
CALL EMP.PROCS.SP_ERROR_LOGGING_DEMO('UK'); 

SELECT * FROM EMP.WORK.SP_ERROR_LOGS; 

--DELETE FROM hrdata.employees;