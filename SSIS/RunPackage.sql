USE SSISDB;

DECLARE 
    @execution_id bigint
,   @var0 smallint = 1;

EXECUTE [catalog].[create_execution] 
    @package_name = N'<PackageName, varchar(255), PS_PAY_DEDUCTION.dtsx>'
,   @execution_id = @execution_id OUTPUT
,   @folder_name = N'<FolderName, varchar(250), HR Import>'
,   @project_name = N'<ProjectName, varchar(250), HR Import Raw>'
,   @use32bitruntime = False
,   @reference_id = 1

SELECT
    @execution_id AS ExecutionId

EXECUTE [catalog].[set_execution_parameter_value] 
    @execution_id
,   @object_type = 50
,   @parameter_name = N'LOGGING_LEVEL'
,   @parameter_value = @var0;

EXECUTE [catalog].[start_execution] 
    @execution_id

WAITFOR DELAY '00:00:10';

SELECT
    OM.operation_message_id
,   OM.operation_id
,   OM.message_time
,   OM.message_type
,   OM.message_source_type
,   OM.message
,   OM.extended_info_id
FROM
    catalog.operation_messages AS OM
WHERE
    OM.operation_id = @execution_id;
