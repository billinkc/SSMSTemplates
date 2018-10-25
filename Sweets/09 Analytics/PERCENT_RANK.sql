-- LEAD
-- http://msdn.microsoft.com/en-us/library/hh213125(v=sql.110).aspx 
-- Accesses data from a subsequent row in the same result set without the 
-- use of a self-join in Microsoft SQL Server 2012 Release Candidate 0 (RC 0). 
-- LEAD provides access to a row at a given physical offset that follows 
-- the current row. Use this analytic function in a SELECT statement to compare 
-- values in the current row with values in a following row.

-- LAG
-- http://msdn.microsoft.com/en-us/library/hh231256(v=sql.110).aspx 
-- Accesses data from a previous row in the same result set without the 
-- use of a self-join in Microsoft SQL Server 2012 Release Candidate 0 (RC 0). 
-- LAG provides access to a row at a given physical offset that comes before 
-- the current row. Use this analytic function in a SELECT statement to compare
-- values in the current row with values in a previous row.

WITH SRC (score, student, affiliation) AS
(
    SELECT
        *
    FROM
    (
        SELECT 100, 'Peter'
        UNION ALL SELECT 90, 'Rufio'
        UNION ALL SELECT 80, 'Tootles'
        UNION ALL SELECT 70, 'Nibs'
        UNION ALL SELECT 60, 'Slightly'
        UNION ALL SELECT 50, 'The Twins'
    ) D (score, boy)
    CROSS APPLY 
    (
        VALUES('Lost Boys')
    ) A (affiliation)
)
SELECT
    S.*
    -- the number of rows with values lower than or equal to the value of r, 
    -- divided by the number of rows evaluated
,   CUME_DIST() OVER (PARTITION BY S.affiliation ORDER BY S.score) AS cumulative_distribution
,   PERCENT_RANK() OVER (PARTITION BY s.affiliation ORDER BY S.score) AS percent_ranks
FROM
    SRC S
ORDER BY
    4 DESC;