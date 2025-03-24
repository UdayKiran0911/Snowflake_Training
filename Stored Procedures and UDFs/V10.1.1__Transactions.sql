// TRANSACTIONS

/*
-- Snowflake by default supports auto commit, but if we want to commit a list of statements as a group then we can put the statements in a transaction.
-- A transaction is a sequence of SQL statements that are committed or rolled back as a unit.
-- A transaction can be started explicitly by executing BEGIN TRANSACTION.
-- A transaction can be ended explicitly by executing COMMIT or ROLLBACK.
-- If you end with COMMIT, all the statements in that transaction will be committed.
-- If you end with ROLLBACK, all the statements in that transaction will be rolled back.
-- When there is failure within the transaction all the statements in that transaction will be rolled back automatically, so transactions help you to rollback the changes in case of failures.
-- If we execute a DDL statement(CREATE, DROP, ALTER) inside a transaction, it will be treated as separate transaction and will be committed immediately.
*/

/*
CREATE OR REPLACE PROCEDURE proc_name()
RETURNS varchar
LANGUAGE sql
AS
$$
DECLARE ...
BEGIN	
	STATEMENT1;
	STATEMENT2;
	BEGIN TRANSACTION;
		STATEMENT3;
		STATEMENT4;
		STATEMENT5;
	COMMIT;	
	STATEMENT6;
RETURN ‘Successfully Completed’;
END;
$$;
*/


CREATE OR REPLACE TABLE HRDATA.SAMPLE_TRAN(id INT);

-- Procedure without a transaction
CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO1()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
    
BEGIN
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(100);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(200);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(300);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES('ABC');
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(500);

    RETURN 'Successful';

END;

CALL EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO1();
// Will result in a error, as 'ABC' is not an int,
// However 100, 200, 300 got insterted


SELECT * FROM HRDATA.SAMPLE_TRAN;

------------------------------

CREATE OR REPLACE TABLE HRDATA.SAMPLE_TRAN(id INT);

-- Procedure with a transaction
CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO2()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
    
BEGIN

INSERT INTO HRDATA.SAMPLE_TRAN VALUES(100);

BEGIN TRANSACTION;
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(200);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(300);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES('ABC');
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(500);
COMMIT;

INSERT INTO HRDATA.SAMPLE_TRAN VALUES(600);

RETURN 'Successful';

END;

CALL EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO2();

SELECT * FROM HRDATA.SAMPLE_TRAN;

-------------------
CREATE OR REPLACE TABLE HRDATA.SAMPLE_TRAN(id INT);

-- Stop the procedure from failing, handle the exception
CREATE OR REPLACE PROCEDURE EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO3()
RETURNS VARCHAR
LANGUAGE SQL
EXECUTE AS CALLER
AS
    
BEGIN

INSERT INTO HRDATA.SAMPLE_TRAN VALUES(100);

BEGIN TRANSACTION;
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(200);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(300);
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES('ABC');
	INSERT INTO HRDATA.SAMPLE_TRAN VALUES(500);
COMMIT;

INSERT INTO HRDATA.SAMPLE_TRAN VALUES(600);

RETURN 'Successful';

EXCEPTION 
    WHEN OTHER THEN
        ROLLBACK;
        RETURN 'Procedure failed and the changes rolled back';

END;

CALL EMP.SPROCS.SP_TRANSACTION_CONTROL_DEMO3();

SELECT * FROM HRDATA.SAMPLE_TRAN;