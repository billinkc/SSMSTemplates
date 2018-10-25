-- Thanks Aaron
-- http://sqlblog.com/blogs/aaron_bertrand/archive/2007/01/11/reviewing-autogrow-events-from-the-default-trace.aspx
-- http://msdn.microsoft.com/en-us/library/ms191263.aspx
-- http://msdn.microsoft.com/en-us/library/ms187491.aspx


DECLARE @path NVARCHAR(260);

SELECT
    @path = REVERSE(SUBSTRING(REVERSE([path]), CHARINDEX('\', REVERSE([path])),260)) + N'log.trc'
FROM
    sys.traces
WHERE
    is_default = 1;

SELECT
    FT.DatabaseName
,   FT.[FileName]
,   FT.SPID
,   FT.Duration
,   FT.StartTime
,   FT.EndTime
,   CASE FT.EventClass
        WHEN 92 THEN 'Data'
        WHEN 93 THEN 'Log'
    END AS FileType
,   FT.IntegerData * 8 AS GrowthSizeIn
FROM
    sys.fn_trace_gettable(@path, DEFAULT) AS FT
WHERE
    FT.EventClass IN (92, 93)
ORDER BY
    FT.StartTime DESC;