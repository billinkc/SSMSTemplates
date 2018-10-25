USE DemoDb

DROP TABLE IF EXISTS dbo.Patient;
CREATE TABLE
    dbo.Patient
(
    PatientId int
,   SSN char(9) NOT NULL
,   PatientName varchar(70) NOT NULL
,   BirthDate date NOT NULL
,   NotSensitive varchar(30) NOT NULL
);

INSERT INTO
    dbo.Patient
(
    PatientId
,   SSN
,   PatientName
,   BirthDate
,   NotSensitive
)
SELECT
*
FROM
(
    VALUES
        (0, '111223333', 'Simon Tam', '1970-01-02', 'Doc')
    ,   (1, '222334444', 'River Tam', '1953-03-04', 'Dancer')
    ,   (2, '333445555', 'Mal Reynolds', '1950-08-11', 'Capn')
)D(PatientId, SSN, PatientName, BirthDate, NotSensitive)
WHERE 
    NOT EXISTS
    (
        SELECT * FROM dbo.Patient AS P WHERE P.PatientId = D.PatientId
    );


-- See data.
-- Run encryption.
-- See data again
SELECT * FROM dbo.Patient AS P;
-- Operand type clash: varchar is incompatible with varchar(8000) encrypted with (encryption_type = 'DETERMINISTIC', encryption_algorithm_name = 'AEAD_AES_256_CBC_HMAC_SHA_256', column_encryption_key_name = 'CEK_Auto1', column_encryption_key_database_name = 'tempdb') collation_name = 'SQL_Latin1_General_CP1_CI_AS'
SELECT * FROM dbo.Patient AS P WHERE P.PatientName = 'Mal Reynolds';
DECLARE @PatientName varchar(70) = 'Mal Reynolds';
EXECUTE sys.sp_executesql N'SELECT * FROM dbo.Patient AS P WHERE P.PatientName = @Name', N'@Name varchar(70)', @name = @patientName;
