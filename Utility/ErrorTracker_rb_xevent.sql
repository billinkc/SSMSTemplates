---------------------------------------------------------------------
-- A script for creating an extended event that tracks
-- failed queries (error severity > 10) to the ring buffer.
-- Every single setting I have is questionable so think it over and
-- evaluate whether these settings are right for you.
--
--  Ignores error 25721 /* The metadata file name "%s" is invalid. Verify that the file exists and that the SQL Server service account has access to it */
--  because I built this against a garbage system that has 
--  file system corruption and will not allow downtime to fix.
--  I ain't bitter about it, neither
---------------------------------------------------------------------
USE master
CREATE EVENT SESSION [what_queries_are_failing_rb] ON SERVER 
ADD EVENT sqlserver.error_reported(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.sql_text,sqlserver.username)
    WHERE ([package0].[greater_than_int64]([severity],(10)) AND [error_number]<>(25721)))
ADD TARGET package0.ring_buffer(SET max_memory=(4096))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO
ALTER EVENT SESSION what_queries_are_failing_rb ON SERVER STATE = START;
USE master
GO
CREATE OR ALTER VIEW dbo.ErrorCapture 
AS
SELECT 
    TX.*
FROM sys.dm_xe_sessions AS s 
JOIN sys.dm_xe_session_targets AS t 
    ON t.event_session_address = s.address
CROSS APPLY (SELECT CONVERT(xml, T.target_data)) AS XM(s)
CROSS APPLY
(
SELECT xeXML = xm.s.query('.')
    FROM XM.s.nodes('/RingBufferTarget/event') AS xm(s)
)xevents(event_data)
CROSS APPLY
(
SELECT
    DATEADD(mi,
    DATEDIFF(mi, GETUTCDATE(), CURRENT_TIMESTAMP),
    xevents.event_data.value('(event/@timestamp)[1]', 'datetime2')) AS [err_timestamp],
    xevents.event_data.value('(event/data[@name="severity"]/value)[1]', 'bigint') AS [err_severity],
    xevents.event_data.value('(event/data[@name="error_number"]/value)[1]', 'bigint') AS [err_number],
    xevents.event_data.value('(event/data[@name="message"]/value)[1]', 'nvarchar(512)') AS [err_message],
    xevents.event_data.value('(event/action[@name="database_id"]/value)[1]', 'int') AS [database_id],
    xevents.event_data.value('(event/action[@name="sql_text"]/value)[1]', 'nvarchar(max)') AS [sql_text],
    xevents.event_data,
    xevents.event_data.value('(event/action[@name="username"]/value)[1]', 'nvarchar(512)') AS [username],
    xevents.event_data.value('(event/action[@name="client_hostname"]/value)[1]', 'nvarchar(512)') AS client_hostname,
    xevents.event_data.value('(event/action[@name="client_app_name"]/value)[1]', 'nvarchar(512)') AS client_app_name,
    'what_queries_are_failing_rb' AS session_name
)TX

WHERE s.name = 'what_queries_are_failing_rb'
    AND t.target_name = N'ring_buffer';
GO
