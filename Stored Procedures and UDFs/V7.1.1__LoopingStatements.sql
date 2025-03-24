-- Looping Statements are used to repeat the same block of code(it can be a single statement or set of statements) multiple times may be with different parameters or values.
-- Snowflake Scripting supports the following types of loops.
-- FOR
-- WHILE
-- REPEAT
-- LOOP

// FOR Loop
-- A FOR loop repeats a sequence of steps for a specified number of times or for each row in a cursor or a result set.
-- Counter based FOR loop - repeats for specific number of times.
-- Cursor based FOR loop – repeats for each row in the cursor or result set.
/*
Counter Based For loop:
FOR  counter  IN  start_value TO end_value 
DO
    < statements to be executed >
END FOR;
*/
/*
Cursor Based For loop:
FOR  row_var  IN  cursor_name
DO
    < statements to be executed >
END FOR;
*/



// WHILE Loop
-- A WHILE loop iterates a sequence of steps until the specified condition is True, when the condition is False, it exits from the loop.
-- If the condition is false before the first iteration, then the body of the loop does not execute even once.
/*
WHILE ( condition(s) )
DO
    < statements to be executed >
END WHILE;
*/



// REPEAT Loop
-- A REPEAT loop iterates a sequence of steps until the specified condition is True , when the condition is False, it exits from the loop.
-- Unlike WHILE loop, here the condition will be tested after executing the body of the loop, so the body will be executed at least once.
/*
REPEAT
    < statements to be executed >
UNTIL ( condition(s) )
END REPEAT;
*/


// LOOP
-- A LOOP executes a sequence of steps until it encounters BREAK command. 
-- These BREAK commands mostly will be part of IF statements, when particular condition is True then applies the BREAK command.
/*
LOOP 
    < statements to be executed >
    ….
   BREAK
   ….
END LOOP;
*/


EXECUTE IMMEDIATE
$$
DECLARE
    i INTEGER;
    j INTEGER;
    pattern VARCHAR DEFAULT '';

BEGIN
    FOR i in 1 TO 5
    DO
        FOR j in 1 to i
        DO
            pattern := pattern || '*\t';
        END FOR;
        pattern := pattern || '\n';
    END FOR;
    RETURN pattern;
END;
$$;

USE DATABASE EMP;
USE SCHEMA SPROCS;

CREATE OR REPLACE PROCEDURE EMP.SPROCS.WHILE_TEST("N" INTEGER)
RETURNS INTEGER
LANGUAGE SQL
COMMENT = 'This SP, would return sum of the first n natural numbers'
EXECUTE AS CALLER
AS

DECLARE
    s INTEGER DEFAULT 0;
    i INTEGER DEFAULT 1;
BEGIN
    WHILE (i <= N)
    DO
        s := s + i;
        i := i + 1;
    END WHILE;
    RETURN s;
END;

CALL EMP.SPROCS.WHILE_TEST(10);