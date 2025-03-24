// UDFs(User Defined Functions)

/*
We can write our own functions when certain functionality is not available through the built-in pre-defined functions, and we call them as User Defined Functions simply as UDFs.
We can write UDFs in snowflake using JavaScript, Scala, Java, Python along with SQL.
A Scalar UDF returns single value for each input value while Tabular UDF returns data in rows and columns that is in table format.
Limitation with SQL UDF’s is we can write single value or single expression or single sql statement in the function definition.
We can create function using CREATE FUNCTION Statement.
We can call the function in the Select statements with parameters.
Never use ‘ ; ‘ at the end of the expression or sql statement in the function definition.

*/

// SCALAR UDFs

/*
CREATE FUNCTION area_of_circle(radius FLOAT)
RETURNS FLOAT
AS
$$
     pi() * radius * radius
$$
;

SELECT area_of_circle(2.5);
*/

/*
CREATE FUNCTION profit()
RETURNS NUMERIC(11, 2)
AS
$$
    SELECT SUM((retail_price - wholesale_price) * number_sold)  FROM purchases
$$
;

SELECT profit();
*/

// TABULAR UDFs
/*
CREATE OR REPLACE FUNCTION orders_for_product(PROD_ID varchar)
RETURNS table (Product_ID varchar, Quantity_Sold numeric(11, 2))
as
$$
    select product_ID, quantity_sold 
	from orders where product_ID = PROD_ID
$$
;
select product_id, quantity_sold
from table(orders_for_product('compostable bags'));
*/

CREATE DATABASE IF NOT EXISTS EMP;
CREATE SCHEMA IF NOT EXISTS UDFs;

-- Create a function to calculate annual tax of employees
CREATE OR REPLACE FUNCTION EMP.UDFs.UDF_CAL_ANNUAL_TAX(MON_GROS_SAL INTEGER)
RETURNS NUMBER
LANGUAGE SQL
AS
$$
SELECT CAST(
CASE WHEN (MON_GROS_SAL * 12 <= 500000) THEN 0
		WHEN ((MON_GROS_SAL * 12) between 500001 and 1000000)
		  THEN ((MON_GROS_SAL * 12) - 500000) * 10/100
		WHEN ((MON_GROS_SAL * 12) between 1000001 and 1500000)
		  THEN ((1000000 - 500000) * 10/100) + (((MON_GROS_SAL * 12) - 1000000) * 20/100)
		ELSE
		  ((1000000 - 500000) * 10/100) + ((1500000 - 1000000) * 20/100) + (((MON_GROS_SAL * 12) - 1500000) * 30/100)
    END
	as NUMBER(10,2))
$$;

UPDATE emp.hrdata.employees SET SALARY = SALARY*10;

SELECT employee_id, first_name, last_name, salary, UDFs.UDF_CAL_ANNUAL_TAX(salary) as ANNUAL_TAX
FROM emp.hrdata.employees;

-------------------
-------------------

CREATE OR REPLACE FUNCTION EMP.PROCS.UDF_TAX_CALCULATION_NEW_REGIME(TOTAL_INCOME NUMBER(20,2), HOME_LOAN_INT NUMBER(20,2), OTHER_DED NUMBER(20,2) )
RETURNS FLOAT
LANGUAGE SQL
AS
$$

-- here 50000 is standard deduction

WITH TA as
(SELECT TOTAL_INCOME - (50000 + HOME_LOAN_INT + OTHER_DED) as TAXABLE_AMOUNT),

TAX as
(SELECT 
CASE WHEN (TA.TAXABLE_AMOUNT <= 300000) 
        THEN 0
	
    WHEN (TA.TAXABLE_AMOUNT between 300001 and 600000) 
        THEN (TA.TAXABLE_AMOUNT - 300000) * (5/100)
	
    WHEN (TA.TAXABLE_AMOUNT between 600001 and 900000)
    	THEN ((600000 - 300000) * (5/100))
			+ ((TA.TAXABLE_AMOUNT - 600000) * (10/100))
			
    WHEN (TA.TAXABLE_AMOUNT between 900001 and 1200000)
    	THEN ((600000 - 300000) * (5/100))
			+ ((900000 - 600000) * (10/100))
			+ ((TA.TAXABLE_AMOUNT - 900000) * (15/100))
			
    WHEN (TA.TAXABLE_AMOUNT between 1200001 and 1500000)
    	THEN ((600000 - 300000) * (5/100))
			+ ((900000 - 600000) * (10/100))
			+ ((1200000 - 900000) * (15/100))
			+ ((TA.TAXABLE_AMOUNT - 1200000) * (20/100))
			
    ELSE ((600000 - 300000) * (5/100))
			+ ((900000 - 600000) * (10/100))
			+ ((1200000 - 900000) * (15/100))
			+ ((1500000 - 1200000) * (20/100))
			+ ((TA.TAXABLE_AMOUNT - 1500000) * (30/100))
    END as TAX_AMT
FROM TA
)

SELECT CAST(TAX_AMT as FLOAT) FROM TAX
			
$$;

SELECT EMP.PROCS.UDF_TAX_CALCULATION_NEW_REGIME(800209, 100000, 20000) as TAX;

/*****************************/
-- Create a function to convert Julian date format to Gregorian date format
CREATE DATABASE IF NOT EXISTS EMP;
CREATE SCHEMA IF NOT EXISTS UDFs;

CREATE OR REPLACE FUNCTION EMP.UDFs.UDF_JUL_GRE_DATE("JDATE" VARCHAR)
RETURNS DATE
LANGUAGE SQL
AS
$$
SELECT 
TO_DATE(DATEADD(DAYS, 
				cast(SUBSTR(JDATE,length(JDATE)-2,3) as number) -1 ,
                DATEADD(YEAR, cast(SUBSTR(JDATE,1,length(JDATE)-3) as number), '1900-01-01')
              )
        ) as GREG_DATE
$$;

SELECT 
UDFs.UDF_JUL_GRE_DATE('111152'), 
UDFs.UDF_JUL_GRE_DATE('098032'),
UDFs.UDF_JUL_GRE_DATE('123232');

-- if we receive Jul date as 5 digit number like 98032, then pad one 0 at left side -- 098032
-- LPAD(JDATE,6,0)

-- Create a function to convert Julian date format to Gregorian date format
CREATE OR REPLACE FUNCTION EMP.UDFs.UDF_JUL_GRE_DATE("JDATE" VARCHAR)
RETURNS DATE
LANGUAGE SQL
AS
$$

WITH JUL_DATE as (SELECT LPAD(JDATE,6,0) as JD)

SELECT 
TO_DATE(DATEADD(DAYS, 
				cast(SUBSTR(JD,length(JD)-2,3) as number) -1 ,
                DATEADD(YEAR, cast(SUBSTR(JD,1,length(JD)-3) as number), '1900-01-01')
              )
        ) as GREG_DATE
FROM JUL_DATE
$$;

SELECT 
UDFs.UDF_JUL_GRE_DATE('111152'), 
UDFs.UDF_JUL_GRE_DATE('098032'),
UDFs.UDF_JUL_GRE_DATE('98032'),
UDFs.UDF_JUL_GRE_DATE('98033');



/******************************************************/
-- Create a function to get the manger names of all employees
CREATE DATABASE IF NOT EXISTS EMP;
CREATE SCHEMA IF NOT EXISTS UDFs;


CREATE OR REPLACE FUNCTION EMP.UDFs.UDF_MANAGER_DETAILS()
RETURNS TABLE(emp_name VARCHAR, manager_name VARCHAR)
LANGUAGE SQL
AS
$$
SELECT 
empl.first_name||' '||empl.last_name as emp_name,
mgr.first_name||' '||mgr.last_name as manager_name
FROM emp.hrdata.employees empl
JOIN emp.hrdata.employees mgr 
ON empl.manager_id = mgr.employee_id
$$;

SELECT emp_name, manager_name FROM TABLE(UDF_MANAGER_DETAILS());

----------------------

-- Create a function to get manager and his direct reporteess
CREATE OR REPLACE FUNCTION EMP.UDFs.UDF_DIRECT_REPORTEES()
RETURNS TABLE(manager_name VARCHAR, direct_reportees VARCHAR)
LANGUAGE SQL
AS
$$
SELECT manager_name, LISTAGG(emp_name, ', ') FROM
(	SELECT 
	empl.first_name||' '||empl.last_name as emp_name,
	mgr.first_name||' '||mgr.last_name as manager_name
	FROM emp.hrdata.employees empl
	JOIN emp.hrdata.employees mgr 
	ON empl.manager_id = mgr.employee_id
) abc
GROUP BY manager_name
$$;


SELECT manager_name, direct_reportees FROM TABLE(UDF_DIRECT_REPORTEES());