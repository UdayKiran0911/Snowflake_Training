USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE EMP;

-- Create Section
CREATE OR REPLACE PROCEDURE EMP.sprocs.sample_storedprocedure("N" VARCHAR)
RETURNS VARCHAR
LANGUAGE SQL
COMMENT = 'This is a sample stored procedure'
EXECUTE AS CALLER
AS

-- Body Section
BEGIN
    RETURN 'Hello ' ||N||'! How are you?';
END;

-- Calling a SP
CALL EMP.sprocs.sample_storedprocedure('Uday Kiran');


-- Find a square root of a number
-- Create Section
CREATE OR REPLACE PROCEDURE EMP.sprocs.get_squareroot("IP_NUMBER" INTEGER)
RETURNS FLOAT
LANGUAGE SQL
COMMENT = 'The SP, will retrun square root of a number'
EXECUTE AS CALLER
AS

-- Declare Section
DECLARE
    sqroot FLOAT;

-- Body Section
BEGIN
    sqroot := SQRT(IP_NUMBER);
    RETURN sqroot;
END;


-- Calling a SP
CALL EMP.sprocs.get_squareroot(4);
CALL EMP.sprocs.get_squareroot(21);
CALL EMP.sprocs.get_squareroot(49);


DROP EMP.SPROCS.SP_FIND_SQRT();