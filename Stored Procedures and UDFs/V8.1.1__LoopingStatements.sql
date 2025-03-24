// Cursors

/*
Cursors are used to iterate through the rows of a table or a view or a resultset, one row at a time.
Mostly we use cursors to do row by row processing of data.
How to use a cursor?
-- Declare Cursor with the query in the declaration section (or) using LET in the body section.
-- Open Cursor to use it in the body of the procedure, this step is not mandatory but very useful if we want to open the cursor dynamically using variables or parameters.
-- Fetch one or more rows and process those rows, this step is not mandatory.
-- Close Cursor after going through or processing all rows, this step is mandatory if you use OPEN to open the cursor.
*/

/*
-- 1. Simple Cursor:
DECLARE  c1 CURSOR for SELECT empid, salary FROM EMPLOYEES;
 (or)
BEGIN
    LET c1 CURSOR for SELECT empid, salary FROM EMPLOYEES;
*/

/*
-- 2. Opening Cursor at run time:
DECLARE
    cur CURSOR for SELECT empid, salary FROM TABLE(?) WHERE dept = ?;
    deptid INTEGER default 10;
BEGIN
    OPEN cur USING(‘EMPLOYEES’,  :deptid);
     … statements …
     CLOSE cur;
     RETURN;
END;
*/


// RESULTSETs
/*
A RESULTSET is a SQL data type that points to the results of a query.
As a RESULTSET is just a pointer to the results, we can do one of the following ways to access those results through the RESULTSET.
    Use the TABLE(resultset_name) to retrieve the results as a query.
    Iterate over the RESULTSET with a cursor.
The difference between Resultset and Cursor is,
For a Cursor the query is executed when we open the cursor or when we access the cursor  in loops, but for a Resultset the query is executed when we assign the query to the Resultset variable itself.
If we want to return a Resultset first we have to convert it as Table type using Table literal.
	RETURN TABLE( resultset_name )
If we want to convert a Cursor to Table type, first we have to convert it to Resultset and then use Table literal like shown below.
	TABLE(RESULTSET_FROM_CURSOR(cursor_name))
*/

/*
-- 1. Declaring Resultset:
DECLARE  res RESULTSET DEFAULT (SELECT empid, salary FROM EMPLOYEES);
 (or)
BEGIN
    LET res RESULTSET := (SELECT empid, salary FROM EMPLOYEES);
*/

/*
-- 2. Assigning query to Resultset
DECLARE 
    res1 RESULTSET;   res2 RESULTSET;   query VARCHAR;   col1 VARCHAR;   col2 VARCHAR;
BEGIN
    res1 := (SELECT empid, salary FROM EMPLOYEES);
    col1 := ‘empid’;    col2 := ‘empname’;
    query := ‘SELECT‘ || col1 || ’ , ’ || col2 || ’ FROM EMPLOYEES ’;
    res2 := (EXECUTE IMMEDIATE :query);
     … statements …
RETURN TABLE(res1);
END;
*/

EXECUTE IMMEDIATE
$$
DECLARE
    cus CURSOR FOR SELECT d.department_name, e.salary FROM EMP.HRDATA.employees e
                    JOIN EMP.HRDATA.departments d ON e.dept_id = d.dept_id
                    WHERE UPPER(d.department_name) = 'SALES';
    dept_name VARCHAR;
    total_Sales INTEGER DEFAULT 0;
BEGIN
    FOR res IN cus
    DO
        dept_name := res.department_name;
        total_sales := total_sales + res.salary;
    END FOR;
    RETURN 'Total Sales for '||dept_name||':'||total_sales;
END;
$$;

-- Find the Total Salary of given department
CREATE OR REPLACE PROCEDURE EMP.SPROCS.DEPT_TOT_SALES("DNAME" VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS

DECLARE
    cus CURSOR FOR SELECT d.department_name, e.salary FROM EMP.HRDATA.employees e
                    JOIN EMP.HRDATA.departments d ON e.dept_id = d.dept_id
                    WHERE UPPER(d.department_name) = UPPER(?);
    dept_name VARCHAR;
    total_Sales INTEGER DEFAULT 0;
BEGIN
    dept_name := DNAME;
    OPEN cus USING(:DNAME);
    FOR res IN cus
    DO
        total_sales := total_sales + res.salary;
    END FOR;
    CLOSE cus;
    RETURN 'Total amount for '||dept_name||': '||total_sales;
END;

CALL EMP.SPROCS.DEPT_TOT_SALES('Sales');
CALL EMP.SPROCS.DEPT_TOT_SALES('IT');
CALL EMP.SPROCS.DEPT_TOT_SALES('Marketing');
CALL EMP.SPROCS.DEPT_TOT_SALES('Unknown');

-- Find top N salaried persons of given department
CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_RS_TOP_N_SALARIED("DEPT" VARCHAR, "N" INTEGER)
RETURNS TABLE(VARCHAR, INTEGER)
LANGUAGE SQL
EXECUTE AS CALLER
AS
DECLARE
    res RESULTSET;
    query VARCHAR;
        
BEGIN

query := 'SELECT first_name||'' ''||last_name as emp_name, salary FROM
            (SELECT e.first_name, e.last_name, e.salary, DENSE_RANK() OVER(PARTITION BY e.dept_id ORDER BY SALARY DESC) as rank
              FROM emp.hrdata.employees e JOIN emp.hrdata.departments d
              ON e.dept_id = d.dept_id
              WHERE UPPER(d.department_name) = UPPER('''||:DEPT||''')
            ) ABC WHERE rank <= '||:N;

res := (EXECUTE IMMEDIATE :query);

RETURN TABLE(res);

END;

CALL EMP.SPROCS.SP_RS_TOP_N_SALARIED('Sales', 3);
CALL EMP.SPROCS.SP_RS_TOP_N_SALARIED('IT', 4);
CALL EMP.SPROCS.SP_RS_TOP_N_SALARIED('finance', 2);
