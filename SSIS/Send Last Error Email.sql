DECLARE
        @profile_name sysname = 'SQLAdmins'
,       @recipients varchar(max) = 'bfellows@valoremconsulting.com'
,       @copy_recipients varchar(max) = NULL
,       @blind_copy_recipients varchar(max) = NULL
,       @subject nvarchar(255) = 'failed package test'
,       @body nvarchar(max) = 'Stuff has failed, fix please'
,       @body_format varchar(20) = NULL
,       @importance varchar(6) = 'NORMAL'
,       @sensitivity varchar(12) = 'NORMAL'
,       @file_attachments nvarchar(max) = NULL
,       @query nvarchar(max) 
   = N'
SELECT
    O.object_name AS FailingPackageName
,   O.object_id
,   O.caller_name
,   O.server_name
,   O.operation_id
,   OM.message_time
,   EM.message_desc
,   D.message_source_desc
,   OM.message
FROM
    SSISDB.catalog.operation_messages AS OM
    INNER JOIN
        SSISDB.catalog.operations AS O
        ON O.operation_id = OM.operation_id
    INNER JOIN
    (
        VALUES
            (-1,''Unknown'')
        ,   (120,''Error'')
        ,   (110,''Warning'')
        ,   (70,''Information'')
        ,   (10,''Pre-validate'')
        ,   (20,''Post-validate'')
        ,   (30,''Pre-execute'')
        ,   (40,''Post-execute'')
        ,   (60,''Progress'')
        ,   (50,''StatusChange'')
        ,   (100,''QueryCancel'')
        ,   (130,''TaskFailed'')
        ,   (90,''Diagnostic'')
        ,   (200,''Custom'')
        ,   (140,''DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages.  The value of the message column for DiagnosticEx is XML text.'')
        ,   (400,''NonDiagnostic'')
        ,   (80,''VariableValueChanged'')
    ) EM (message_type, message_desc)
        ON EM.message_type = OM.message_type
    INNER JOIN
    (
        VALUES
            (10,''Entry APIs, such as T-SQL and CLR Stored procedures'')
        ,   (20,''External process used to run package (ISServerExec.exe)'')
        ,   (30,''Package-level objects'')
        ,   (40,''Control Flow tasks'')
        ,   (50,''Control Flow containers'')
        ,   (60,''Data Flow task'')
    ) D (message_source_type, message_source_desc)
        ON D.message_source_type = OM.message_source_type
WHERE
    OM.operation_id = 
    (  
        SELECT 
            MAX(OM.operation_id)
        FROM
            SSISDB.catalog.operation_messages AS OM
        WHERE
            OM.message_type = 120
    )
    AND OM.message_type IN (120, 130);
'
,       @execute_query_database sysname = NULL
,       @attach_query_result_as_file bit = 0
,       @query_attachment_filename nvarchar(260) = NULL
,       @query_result_header bit = 1
,       @query_result_width int = 256
,       @query_result_separator char(1) = char(13)
,       @exclude_query_output bit  = 0
,       @append_query_error bit = 0
,       @query_no_truncate bit = 0
,       @query_result_no_padding bit = 0
,       @mailitem_id int = NULL
,       @from_address varchar(max) = NULL
,       @reply_to varchar(max) = NULL;

EXECUTE msdb.dbo.sp_send_dbmail
    @profile_name 
,   @recipients
,   @copy_recipients
,   @blind_copy_recipients
,   @subject
,   @body
,   @body_format
,   @importance
,   @sensitivity
,   @file_attachments
,   @query
,   @execute_query_database
,   @attach_query_result_as_file
,   @query_attachment_filename
,   @query_result_header
,   @query_result_width
,   @query_result_separator
,   @exclude_query_output
,   @append_query_error
,   @query_no_truncate
,   @query_result_no_padding
,   @mailitem_id OUTPUT
,   @from_address
,   @reply_to;
