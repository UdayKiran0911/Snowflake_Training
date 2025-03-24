-- Ref: https://quickstarts.snowflake.com/guide/getting_started_with_snowflake_devops/index.html#0
-- Ref: https://quickstarts.snowflake.com/guide/devops_dcm_schemachange_github/#0


/*
-- Establish a connection between Snowflake and a GitHub repository
-- Setup access to Snowflake Marketplace data
-- Create a vectorized Python UDF making use of dynamic file access
-- Create a data engineering pipeline to process data from multiple sources
-- Orchestrate the pipeline with tasks
-- Make declarative changes to the pipeline with Create-or-Alter and Python APIs
-- Separate dev and prod environments with Jinja templating
-- Deploy the pipeline via an automated CI/CD pipeline
-- Enrich your data with Cortex LLM functions
*/

/*
What you will need

Snowflake
    -- A Snowflake Account
    -- A Snowflake user with ACCOUNTADMIN permissions
    -- Anaconda Terms & Conditions accepted. See Using Third-Party Packages.
GitHub
    -- A GitHub account. If you don't already have one, you can create one for free.
*/

/*
    Snowflake devops building blocks for Data Engineering
    -- Declerative Definiations
        -- CREATE or ALTER: Database change management: Applies neccessary updates (create, alter, execute) to mainiatin consitency across database objects.
        -- EXECUTE IMMEDIATE FROM
        -- SNOWFLAKE CLI: Runs automated commands using snowflake CLI as part of CI/CD Pipeline(GitHub/Jenkins/Azure Devops) CLI commands automate deployments, collaborate with version control and integrate with other CI/CD tools.
        -- GIT INTEGRATION: Fetches project config and data pipelines (schema, tables, scripts) from a GIT repo, triggering the deployment workflow
        -- PYTHON APIs: Use Snowflake Python APIs to manage Snowflake resources from DevOps
    -- Templating
    -- Dev Tools
    -- Source Control
    -- APIs and Interfaces
*/

ALTER USER "UDAYKIRAN" SET RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0R51tliKbnLdyOmxche3
VmZx+mN19PkF6auB6Ei5XuiAVjdpwRLP92f5XktUSq1hCj04MKXBKtGxV2zJF3et
C322DmEubTcafsr2ROPTlDBR0j6PW+R691UDOOF0s2AX3qzJl5xdKDh9TnlA2cbd
TOUAyPe75lZOmB77koydIRy8HfkPnXRSX2whU4h/0ExKbIoNC2ogVmiK6d6T4PmR
HJCSTV8ef+YtLPaP6WvRYeT6IqxQZqCNw6RfJO57fGHhs51cuKUpBTVTi9bEvAWZ
qe9GhmBlOS8T5wBRtiNn4VIDhyWN4GpXM+147HbUOrXSkfaxAVQXGWMcFM3nuLgP
kwIDAQAB';


