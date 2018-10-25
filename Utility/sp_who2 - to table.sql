IF OBJECT_ID('tempdb..#sp_who2') IS NOT NULL
BEGIN
    DROP TABLE #sp_who2;
END
CREATE TABLE #sp_who2
(
    SPID int
,   Status varchar(255)
,   Login varchar(255)
,   HostName varchar(255)
,   BlkBy varchar(255)
,   DBName varchar(255)
,   Command varchar(255)
,   CPUTime int
,   DiskIO int
,   LastBatch varchar(255)
,   ProgramName varchar(255)
,   SPID2 int
,   REQUESTID int
);

INSERT INTO #sp_who2
EXECUTE master.sys.sp_who2;

SELECT 
    SW.*
FROM
    #sp_who2 AS SW;
