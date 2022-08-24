---------------------------------------------------------------------
-- A script for finding who changed something in the database
---------------------------------------------------------------------
SELECT TOP 100
    f.ObjectName
,   f.EventClass
,   t.path
,   t.start_time AS TraceStartTime
,   t.last_event_time AS TraceLastEventTime
,   f.StartTime AS ChangeStartTime
,   t.event_count
,   f.DatabaseID
-- I think I need to know distinct count on that
,   f.TransactionID
,   f.NTUserName
--,   f.NTDomainName
,   f.HostName
,   f.ClientProcessID
--,   f.ApplicationName
,   f.LoginName
,   f.SPID
,   f.EventSubClass
,   F.ObjectID
,   F.EventClass
,   F.ObjectType
,   F.ObjectName
,   F.DatabaseName
SELECT MAX(f.starttime)
FROM
    sys.traces t
    CROSS APPLY sys.fn_trace_gettable(REVERSE(SUBSTRING(REVERSE(t.PATH), CHARINDEX('\', REVERSE(t.PATH)), 260)) + N'log.trc', DEFAULT) F
WHERE
    t.is_default = 1
    --AND F.EventClass IN
    --(
    --    46 /*Object:Created*/
    --,   47 /*Object:Dropped*/
    --,   164 /*Object:Altered*/
    --)
    -- Find permission changes by uncommenting this
    --(102, 103, 104, 105, 106, 108, 109, 110, 111)
    /*AND f.DatabaseName = 'ABC'*/
	/*
    AND f.ObjectName IN
    (
        'tblFoo'
    )
	*/
    AND f.StartTime > '2022-07-22'
    --AND F.ObjectName  LIKE '%spAutoApprove%'
    AND F.DatabaseID > 4
ORDER BY ChangeStartTime DESC
	;
