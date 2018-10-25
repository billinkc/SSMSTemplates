SELECT
	db_name(S.dbid) as databaseName
,   S.fileid
,   S.name as fileSymbolicName
,   S.groupid
,   cast((S.size * 8 / 1024) as sysname) + ' MB' as sizeInMB
,   CASE (S.status & 0x100000) 
	    WHEN 0x100000
		    THEN CAST(S.growth AS sysname) + '%'
	    ELSE CAST((S.growth * 8 / 1024) AS sysname) + ' MB'
    END AS growth
FROM   
	master.sys.sysaltfiles AS S
WHERE 
	S.dbid = db_id();
