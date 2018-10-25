-- DENSE_RANK()
-- The DENSE_RANK function is the third of four windowing functions
-- introduced in SQL Server 2005. DENSE_RANK is nearly identical to RANK
-- except that in the case of a tie or duplicate values, DENSE_RANK will
-- leave no gaps in numbering.
-- Syntax
-- The syntax for DENSE_RANK is identical to RANK(). It's DENSE_RANK()
-- OVER (ORDER BY _) , parenthesis required. Using the upcoming SQL
-- Saturday calendar, I added a call to DENSE_RANK() based on event date
-- to introduce a rank column.


-- This query demonstrates the use of the DENSE_RANK function
-- Notice the ranks for rows with same key (event_date) are
-- ranked equally and the subsequent rank number leaves
-- no gaps in the numbers.
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
,   DENSE_RANK() OVER (ORDER BY SS.event_date ASC) AS zee_dense_rank
FROM
    SQL_SATURDAY SS


-- What to notice
-- I created a new column called "zee_dense_rank" with the invocation of
-- the DENSE_RANK function. Because I ordered it by dates, and we have 3
-- events all on 2010-09-18, the rank starts at 1 for Nashville
-- represent! East Iowa, San Diego and Raleigh battled it out for
-- supremacy on 2010-09-18 and it was a three way tie at 2 which resulted
-- in Colorado being ranked 3rd versus 5th if RANK had been used.
--
-- Availability
-- SQL Server 2005+