--Create csv format in bronze schema
CREATE OR REPLACE FILE FORMAT csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
FIELD_OPTIONALLY_ENCLOSED_BY = '"'
SKIP_HEADER = 1;

--Create stages for introducing tables
CREATE OR REPLACE STAGE bronze.updated_stg;
CREATE OR REPLACE STAGE bronze.landing_stg;
