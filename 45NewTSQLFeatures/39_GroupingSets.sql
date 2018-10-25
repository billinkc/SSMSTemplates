-- 2008+
-- Grouping sets
-- http://technet.microsoft.com/en-us/library/bb510427.aspx
-- http://blogs.msdn.com/b/craigfr/archive/2007/10/11/grouping-sets-in-sql-server-2008.aspx

-- Need to aggregate at different levels?  GROUPING SETS do that
;
WITH CTE (event_number, state, year) AS
(
    -- some data faked to make for slightly more interesting results
    SELECT 66, 'CO', 2011
    UNION ALL SELECT 63, 'TX', 2011
    UNION ALL SELECT 57, 'TX', 2010
    UNION ALL SELECT 56, 'TX', 2009
    UNION ALL SELECT 35, 'TX', 2010
    UNION ALL SELECT 53, 'MO', 2010
    UNION ALL SELECT 72, 'HI', 2010
    UNION ALL SELECT 72, 'LO', 2010
    UNION ALL SELECT 72, 'LO', 2010
)
SELECT
     state
,   MIN(event_number) first_event
,   MAX(event_number) last_event
,   MIN(year) AS first_year
,   MAX(year) AS last_year
,   COUNT(1) AS rc
FROM CTE
GROUP BY
    GROUPING SETS (state, event_number, (state, event_number))
