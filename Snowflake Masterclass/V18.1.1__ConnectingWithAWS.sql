-- Step1: in AWS Create S3 Bucket
-- Step2: Create 2 folder csv, json and upload the corresponding files into them
-- Step3: Navigate to "IAM">>"Roles">>"Create Role"
-- Step4: Choose "AWS Account" option
-- Step5: Check "Require External ID", in the External ID Field add: 00000 (for now), click "Next"
-- Step6: In Add Permission page, Search and Select "AmazonS3FullAccess", click "Create Role"
-- Step7: in the next page, Provide a name for the Role and Click create.
-- Collect the ARN: arn:aws:iam::263130564936:role/SnowflakeAwsAccessRole

-- Excute the storage integration script below (both create and DESC)
-- collect "STORAGE_AWS_IAM_USER_ARN" and "STORAGE_AWS_EXTERNAL_ID" values

-- go back to IAM in AWS and Select "SnowflakeAWSAccessRole" >> go to Trust Relationship tab >> "Edit trust policy"
-- replace Principal>>AWS with the STORAGE_AWS_IAM_USER_ARN value
-- and StringEquals>>sts:ExternalID with STORAGE_AWS_EXTERNAL_ID value


-- 
// Create storage integration object

create or replace storage integration s3_int
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE 
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::263130564936:role/SnowflakeAwsAccessRole'
  STORAGE_ALLOWED_LOCATIONS = ('s3://snowflakeawsaccess/csv/', 's3://snowflakeawsaccess/json/')
   COMMENT = 'This an optional comment';
   
   
// See storage integration properties to fetch external_id so we can update it in S3
DESC integration s3_int;



// Create table first
CREATE OR REPLACE TABLE OUR_FIRST_DB.PUBLIC.movie_titles (
  show_id STRING,
  type STRING,
  title STRING,
  director STRING,
  cast STRING,
  country STRING,
  date_added STRING,
  release_year STRING,
  rating STRING,
  duration STRING,
  listed_in STRING,
  description STRING );
  
  

// Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;
    
    
 // Create stage object with integration object & file format object
CREATE OR REPLACE stage MANAGE_DB.external_stages.csv_folder
    URL = 's3://snowflakeawsaccess/csv/'
    STORAGE_INTEGRATION = s3_int
    FILE_FORMAT = MANAGE_DB.file_formats.csv_fileformat;



// Use Copy command       
COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.external_stages.csv_folder
    files = ('netflix_titles.csv');    
    
    
// Create file format object
CREATE OR REPLACE file format MANAGE_DB.file_formats.csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE    
    FIELD_OPTIONALLY_ENCLOSED_BY = '"' ;

COPY INTO OUR_FIRST_DB.PUBLIC.movie_titles
    FROM @MANAGE_DB.external_stages.csv_folder
    files = ('netflix_titles.csv');;
    
SELECT * FROM OUR_FIRST_DB.PUBLIC.movie_titles;