USE SSISDB
GO

-- You must be in SQLCMD mode
-- setvar isPacPath "C:\sandbox\SSDTDeploy\TSQLDeploy\bin\Development\TSQLDeploy.ispac"
:setvar isPacPath "<isPacFilePath, nvarchar(4000), C:\sandbox\SSDTDeploy\TSQLDeploy\bin\Development\TSQLDeploy.ispac>"

DECLARE
    @folder_name nvarchar(128) = 'TSQLDeploy'
,   @folder_id bigint = NULL
,   @project_name nvarchar(128) = 'TSQLDeploy'
,   @project_stream varbinary(max)
,   @operation_id bigint = NULL;

-- Read the zip (ispac) data in from the source file
SELECT
    @project_stream = T.stream
FROM
(
    SELECT 
        *
    FROM 
        OPENROWSET(BULK N'$(isPacPath)', SINGLE_BLOB ) AS B
) AS T (stream);

-- Test for catalog existences
IF NOT EXISTS
(
    SELECT
        CF.name
    FROM
        catalog.folders AS CF
    WHERE
        CF.name = @folder_name
)
BEGIN
    -- Create the folder for our project
    EXECUTE [catalog].[create_folder] 
        @folder_name
    ,   @folder_id OUTPUT;
END

-- Actually deploy the project
EXECUTE [catalog].[deploy_project] 
    @folder_name
,   @project_name
,   @project_stream
,   @operation_id OUTPUT;

-- Check to see if something went awry
SELECT
    OM.* 
FROM
    catalog.operation_messages AS OM
WHERE
    OM.operation_id = @operation_id;

