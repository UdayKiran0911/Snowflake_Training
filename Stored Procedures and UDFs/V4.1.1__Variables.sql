// VARIABLES
/*
In Snowflake Scripting(Procedures written in SQL Language) we can declare variables at 2 places.
Declare Section:
     variable_name  data_type ;
     variable_name  data_type  default < value or expression > ;
Body Section: Using LET Keyword
     LET variable_name  < := or default > < value or expression > ;
     LET variable_name  data_type  < := or default >  < value or expression > ;
Here data_type can be..
Any SQL Data type or
Cursor or
Resultset or
Exception
*/

//VARIABLE ASSIGNEMNT
/*
1. We can assign a value to variables by using default and := operator.
2. We use “ : ” infront of variables to access the value stored in it and this is mandatory for the variables used in SQL statements. And we call these variables as Binding Variables (Denoted with : or sometimes with ?)
3. By using SELECT statement also we can assign values to variables.
Below are few examples:
DECLARE
     first_name VARCHAR default ‘This is’;
     full_name VARCHAR;
BEGIN
     LET middle_name := ‘  ‘;
     LET last_name default ‘Snowflake Scripting’;
     full_name := first_name || middle_name || last_name ;

     SELECT :First_Name || :Middle_Name || :Last_Name into :Full_Name;
*/

//SESSION VARIABLE
/*
We can define Session level variables as well and can use these variables only in that session. 
We use SET to declare these Session Variables.
SET  A = 10;
SET  name = ‘Jana’;
SET  (B, C, place) = (100, 35, ‘Hyderabad’);
These Session variables can be accessed by using “ $ “ infront of the session variable. 
We can’t modify or change the value of the session variable inside the program.
*/

//EXECUTE IMMEDIATE
/*
We can execute a block of code using “Execute Immediate” like below

EXECUTE IMMEDIATE 
$$
    DECLARE
        profit number(38, 2) DEFAULT 0.0;
    BEGIN
        LET cost number(38, 2) := 100.0;
        LET revenue number(38, 2) DEFAULT 110.0;
        profit := revenue - cost;

        RETURN profit;
    END;
$$
;
*/

-- Variable Declaration and Assignment

EXECUTE IMMEDIATE 
$$
    DECLARE
        First_Name VARCHAR default 'This is';
		Last_Name VARCHAR;
		Full_Name STRING;
    BEGIN
        LET Middle_Name := ' ';
        Last_Name := 'Snowflake Scripting';
		
		Full_Name := First_Name || Middle_Name || Last_Name;        
		-- SELECT :First_Name || :Middle_Name || :Last_Name into :Full_Name;
        
		RETURN Full_Name;
    END;
$$
;

EXECUTE IMMEDIATE $$
    DECLARE
        profit number(38, 2) DEFAULT 0.0;
    BEGIN
        LET cost number(38, 2) := 100.0;
        LET revenue number(38, 2) DEFAULT 110.0;

        profit := revenue - cost;
        RETURN profit;
    END;
$$
;

-- Session Level Variables
SET A=60;
SET (B, C) = (220, 10);
SET Age = 'My Age is ';

EXECUTE IMMEDIATE 
$$
    DECLARE
        D Integer;
        
    BEGIN
        D := ($A + $B) / $C;        
		RETURN $Age || D;
    END;
$$
;

SET (A, B, place) = (30, 52, 'Hyderabad');

EXECUTE IMMEDIATE 
$$
    BEGIN
    RETURN $place || ' - ' || ($A+$B);
    
    END;
$$;

-- Session Variables can't be modified
SET A=60;
EXECUTE IMMEDIATE 
$$
    BEGIN
        --A := 100;
        $A := 100;
		RETURN $A;
    END;
$$;
