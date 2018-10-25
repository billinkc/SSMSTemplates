-- EOMONTH
-- http://msdn.microsoft.com/en-us/library/hh213020(v=sql.110).aspx
-- Returns the end of the month. It's not rocket science

SELECT 
    EOMONTH(CURRENT_TIMESTAMP) AS EndOfThisMonth
,   EOMONTH(CURRENT_TIMESTAMP, +1) AS EndOfNextMonth
,   EOMONTH(CURRENT_TIMESTAMP, -1) AS EndOfLastMonth
,   DATEADD(d, 1, EOMONTH(CURRENT_TIMESTAMP, -1)) AS BeginingOfThisMonth
,   DATEADD(d, 1, EOMONTH(CURRENT_TIMESTAMP)) AS BeginingOfNextMonth