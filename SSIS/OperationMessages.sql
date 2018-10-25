--- http://technet.microsoft.com/en-us/library/ff877994.aspx
-- This query translates the message_type from SSISDB.catalog.operation_messages
-- into useful text
SELECT
    D.message_type
,   D.message_desc
FROM
(
    VALUES
        (-1,'Unknown')
    ,   (120,'Error')
    ,   (110,'Warning')
    ,   (70,'Information')
    ,   (10,'Pre-validate')
    ,   (20,'Post-validate')
    ,   (30,'Pre-execute')
    ,   (40,'Post-execute')
    ,   (60,'Progress')
    ,   (50,'StatusChange')
    ,   (100,'QueryCancel')
    ,   (130,'TaskFailed')
    ,   (90,'Diagnostic')
    ,   (200,'Custom')
    ,   (140,'DiagnosticEx Whenever an Execute Package task executes a child package, it logs this event. The event message consists of the parameter values passed to child packages.  The value of the message column for DiagnosticEx is XML text.')
    ,   (400,'NonDiagnostic')
    ,   (80,'VariableValueChanged')
) D (message_type, message_desc);


-- Where was the error message generated?
SELECT
    D.message_source_type
,   D.message_source_desc
FROM
(
    VALUES
        (10,'Entry APIs, such as T-SQL and CLR Stored procedures')
    ,   (20,'External process used to run package (ISServerExec.exe)')
    ,   (30,'Package-level objects')
    ,   (40,'Control Flow tasks')
    ,   (50,'Control Flow containers')
    ,   (60,'Data Flow task')
) D (message_source_type, message_source_desc);



SELECT
    D.message_desc
,   O.caller_name
,   PC.*
FROM
    CustomerDM.MIETL.PackageControl AS PC
    INNER JOIN
        SSISDB.catalog.operations AS O
        ON O.operation_id = PC.ExecutionID
    INNER JOIN
    (
        VALUES
            ('created', 1)
        ,   ('running', 2)
        ,   ('canceled', 3)
        ,   ('failed', 4)
        ,   ('pending', 5)
        ,   ('ended unexpectedly', 6)
        ,   ('succeeded', 7)
        ,   ('stopping', 8)
        ,   ('completed', 9)
    ) D (message_desc, message_type)
    ON D.message_type = O.status
WHERE
    PC.StartTime > cast(current_timestamp as date);


-- https://msdn.microsoft.com/en-us/library/hh479590.aspx
SELECT
    EMCD.*
FROM
(
    -- event message context
    VALUES
    (10,'Task','State of a task when an error occurred.')
,   (20,'Pipeline','Error from a pipeline component: source, destination, or transformation component.')
,   (30,'Sequence','State of a sequence.')
,   (40,'For Loop','State of a For Loop.')
,   (50,'Foreach Loop','State of a Foreach Loop')
,   (60,'Package','State of the package when an error occurred.')
,   (70,'Variable','Variable value')
,   (80,'Connection manager','Properties of a connection manager.')
) EMCD(context_type,context_type_name,context_description);