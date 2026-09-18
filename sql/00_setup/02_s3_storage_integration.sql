USE ROLE URBANASSIST_ENGINEER;

USE DATABASE URBANASSIST_DB;

USE SCHEMA OPS;

CREATE OR REPLACE STORAGE INTEGRATION URBANASSIST_S3_INT
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = 'S3'
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::535237073849:role/urban360-dev-role'
  STORAGE_ALLOWED_LOCATIONS = ('s3://urbanassistdata360-buck-dev/urbanassist/')
  COMMENT = 'Read-only integration for UrbanAssist source files';

-- Copy STORAGE_AWS_IAM_USER_ARN and STORAGE_AWS_EXTERNAL_ID from this result
-- into the AWS IAM role trust policy. The runbook provides the exact sequence.
-- Rerun this command after editing the AWS trust policy to compare the values.
DESC INTEGRATION URBANASSIST_S3_INT;