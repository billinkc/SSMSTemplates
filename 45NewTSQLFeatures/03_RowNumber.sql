-- ROW_NUMBER()
-- The ROW_NUMBER function is one of four windowing functions introduced
-- in SQL Server 2005. ROW_NUMBER() is a monotomically increasing
-- function for each partition within a query. That's a fancy way of
-- saying starting at 1, add 1 for every row you encounter. The partition
-- is simply the signal to start counting over.
-- Syntax
-- The syntax simple, it's ROW_NUMBER() OVER (ORDER BY _) , parenthesis
-- required. Using the query from the CTE introduction, I added a call to
-- row_number() to introduce a sequential row number column.

-- This query demonstrates the ROW_NUMBER function
-- along with partitioning
;
WITH BORDER_STATES (state_name, abbreviation) AS
(
    SELECT 'IOWA', 'IA'
    UNION ALL SELECT 'NEBRASKA', 'NE'
    UNION ALL SELECT 'OKLAHOMA', 'OK'
    UNION ALL SELECT 'KANSAS', 'KS'
    UNION ALL SELECT 'ILLINOIS', 'IL'
    UNION ALL SELECT 'KENTUCKY', 'KY'
    UNION ALL SELECT 'TENNESSEE', 'TN'
)
, BEST_STATE AS
(
    SELECT 'MISSOURI' AS state_name, 'MO' AS state_abbreviation
)
, JOINED AS
(
    SELECT M.*, 1 AS state_rank FROM BEST_STATE M
    UNION
    SELECT BS.*, 2 AS state_rank FROM BORDER_STATES BS
)
SELECT
    J.*
,   ROW_NUMBER() OVER (PARTITION BY J.state_rank ORDER BY J.state_rank) AS zee_row_number
FROM
    JOINED J

-- What to notice
-- I created a new column called "zee_row_number" with the invocation of
-- the ROW_NUMBER function. I partitioned my results on the state_rank
-- which lead to my data being segmented into two sets, state_rank 1 and
-- 2. Missouri being the only element in its set is assigned
-- zee_row_number of 1. Within the second set, Iowa was selected as the
-- first element of that set. Your mileage may vary. After that, the
-- other 6 rows had their zee_row_number incremented by 1.
--
-- Availability
-- SQL Server 2005+
