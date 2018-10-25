-- This query demonstrates the use of the RANK function
-- Notice the ranks for rows with same key (event_date) are 
-- ranked equally and the subsequent rank number behaves
-- like an identity insert that was rolled back, i.e. gaps
-- in the meaningless identifiers that someone (QA) will question
;
WITH SQL_SATURDAY (event_date, event_name, event_location) AS
(
SELECT CAST('Aug 21, 2010' as datetime), 'SQLSaturday #51', 'Nashville 2010'
UNION ALL SELECT 'Sep 18, 2010', 'SQLSaturday #46', 'Raleigh 2010'
UNION ALL SELECT 'Sep 18, 2010', 'SQLSaturday #50', 'East Iowa 2010'
UNION ALL SELECT 'Sep 18, 2010', 'SQLSaturday #55', 'San Diego 2010'
UNION ALL SELECT 'Sep 25, 2010', 'SQLSaturday #52', 'Colorado 2010'
UNION ALL SELECT 'Oct 2, 2010', 'SQLSaturday #53', 'Kansas City 2010'
UNION ALL SELECT 'Oct 2, 2010', 'SQLSaturday #48', 'Columbia 2010'
UNION ALL SELECT 'Oct 16, 2010', 'SQLSaturday #49', 'Orlando 2010'
UNION ALL SELECT 'Oct 23, 2010', 'SQLSaturday #54', 'Salt Lake City 2010'
UNION ALL SELECT 'Oct 23, 2010', 'SQLSaturday #56', 'Dallas (BI Edition) 2010'
UNION ALL SELECT 'Oct 29, 2010', 'SQLSaturday #58', 'Minnesota 2010'
UNION ALL SELECT 'Nov 20, 2010', 'SQLSaturday #59', 'New York City 2010'
UNION ALL SELECT 'Jan 22, 2011', 'SQLSaturday #45', 'Louisville 2011'
UNION ALL SELECT 'Jan 29, 2011', 'SQLSaturday #57', 'Houston 2011'
UNION ALL SELECT 'Feb 5, 2011', 'SQLSaturday #47', 'Phoenix 2011'
)
SELECT
    SS.* 
,   RANK() OVER (ORDER BY SS.event_date ASC) AS zee_rank
FROM 
    SQL_SATURDAY SS
