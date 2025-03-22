-- Loading Unstructured Data
    -- Create stages
    -- Load raw data : Type = VARIANT
    -- Analyse and parse
    -- Flatten and load


// First step: Load Raw JSON

Use database manage_db;
Create or replace schema manage_db.FILE_FORMATS;

CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
     url='s3://bucketsnowflake-jsondemo';

list @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE;

CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
    TYPE = JSON;
    
    
CREATE OR REPLACE table OUR_FIRST_DB.PUBLIC.JSON_RAW (
    raw_file variant);
    
COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    file_format= MANAGE_DB.FILE_FORMATS.JSONFORMAT
    files = ('HR_data.json');
    
   
SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


SELECT raw_file:city from OUR_FIRST_DB.PUBLIC.JSON_RAW;
SELECT $1:first_name from OUR_FIRST_DB.PUBLIC.JSON_RAW;
SELECT $1:first_name::string as First_Name from OUR_FIRST_DB.PUBLIC.JSON_RAW;
SELECT raw_file:id::int as ID from OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT 
    raw_file:id::int as ID,
    raw_file:first_name::string as First_Name,
    raw_file:last_name::string as Last_Name,
    raw_file:gender::string as Gender
from OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT raw_file:job from OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT 
    raw_file:id::int as ID,
    raw_file:first_name::string as First_Name,
    raw_file:last_name::string as Last_Name,
    raw_file:gender::string as Gender,
    raw_file:job.salary::int as Salary,
    raw_file:job.title::string as Title,
    raw_file:spoken_languages.title::string as Title
from OUR_FIRST_DB.PUBLIC.JSON_RAW;

SELECT 
    raw_file:spoken_languages as Spoken_languages,
    array_size(raw_file:spoken_languages) as Spoken_languages_count
from OUR_FIRST_DB.PUBLIC.JSON_RAW;

Select 
    raw_file:first_name::string as first_Name,
    f.value:language::string as language,
    f.value:level::string as level,
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(raw_file:spoken_languages)) as f;

CREATE OR REPLACE TABLE LANGUAGES as 
Select 
    raw_file:first_name::string as first_Name,
    f.value:language::string as language,
    f.value:level::string as level,
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(raw_file:spoken_languages)) as f;

SELECT * from LANGUAGES;

truncate table LANGUAGES;

insert into LANGUAGES 
Select 
    raw_file:first_name::string as first_Name,
    f.value:language::string as language,
    f.value:level::string as level,
from OUR_FIRST_DB.PUBLIC.JSON_RAW, table(flatten(raw_file:spoken_languages)) as f;

SELECT * from LANGUAGES;






-- <ASSIGNMENT>
-- Use database manage_db;
-- Create or replace schema manage_db.FILE_FORMATS;

-- CREATE OR REPLACE stage MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
--      url='s3://snowflake-assignments-mc/unstructureddata/';

-- list @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE;

-- CREATE OR REPLACE file format MANAGE_DB.FILE_FORMATS.JSONFORMAT
--     TYPE = JSON;
    
    
-- CREATE OR REPLACE table OUR_FIRST_DB.PUBLIC.JSON_RAW (
--     raw_file variant);
    
-- COPY INTO OUR_FIRST_DB.PUBLIC.JSON_RAW
--     FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
--     file_format= MANAGE_DB.FILE_FORMATS.JSONFORMAT
--     files = ('Jobskills.json');
    
   
-- SELECT * FROM OUR_FIRST_DB.PUBLIC.JSON_RAW;


-- Select * from (
-- SELECT 
--     raw_file:first_name::string as First_Name,
--     raw_file:last_name::string as Last_Name,
--     raw_file:Skills[0]::string as Skill_1,
--     raw_file:Skills[1]::string as Skill_2
-- from OUR_FIRST_DB.PUBLIC.JSON_RAW)
-- where First_Name = 'Florina'
-- ;
