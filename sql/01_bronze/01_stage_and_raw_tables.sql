USE ROLE URBANASSIST_ENGINEER;

USE WAREHOUSE URBANASSIST_WH; 

USE DATABASE URBANASSIST_DB;

USE SCHEMA OPS;

CREATE FILE FORMAT IF NOT EXISTS JSON_GZIP_FF
  TYPE = JSON
  COMPRESSION = AUTO --It shows that compression type is analysed during read time and work accordingly
  STRIP_OUTER_ARRAY = FALSE --If data is in format [{},{},{}] Then TRUE
  COMMENT = 'JSON Lines input; gzip is detected automatically';

CREATE STAGE IF NOT EXISTS URBANASSIST_S3_STAGE
  URL = 's3://urbanassistdata360-buck-dev/urbanassist/'
  STORAGE_INTEGRATION = URBANASSIST_S3_INT
  FILE_FORMAT = JSON_GZIP_FF
  COMMENT = 'External stage rooted at the UrbanAssist project prefix';

LIST @URBANASSIST_S3_STAGE;

CREATE TABLE IF NOT EXISTS BRONZE.RAW_BOOKING_EVENTS (
  payload             VARIANT       NOT NULL,
  source_filename     VARCHAR       NOT NULL,
  source_row_number   NUMBER        NOT NULL,
  ingested_at         TIMESTAMP_LTZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  CONSTRAINT uq_raw_booking_source UNIQUE (source_filename, source_row_number)
)
COMMENT = 'Append-only booking snapshots exactly as received from S3';


CREATE TABLE IF NOT EXISTS BRONZE.RAW_PROVIDER_EVENTS (
  payload             VARIANT       NOT NULL,
  source_filename     VARCHAR       NOT NULL,
  source_row_number   NUMBER        NOT NULL,
  ingested_at         TIMESTAMP_LTZ NOT NULL DEFAULT CURRENT_TIMESTAMP(),
  CONSTRAINT uq_raw_provider_source UNIQUE (source_filename, source_row_number)
)
COMMENT = 'Append-only provider snapshots used to build the SCD2 dimension';

CREATE TABLE IF NOT EXISTS BRONZE.RAW_CUSTOMERS (
  payload             VARIANT       NOT NULL,
  source_filename     VARCHAR       NOT NULL,
  source_row_number   NUMBER        NOT NULL,
  ingested_at         TIMESTAMP_LTZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'One-time customer reference landing table';

-- Create the service-catalogue landing table used to build DIM_SERVICE.
CREATE TABLE IF NOT EXISTS BRONZE.RAW_SERVICES (
  payload             VARIANT       NOT NULL,
  source_filename     VARCHAR       NOT NULL,
  source_row_number   NUMBER        NOT NULL,
  ingested_at         TIMESTAMP_LTZ NOT NULL DEFAULT CURRENT_TIMESTAMP()
)
COMMENT = 'One-time service reference landing table';
