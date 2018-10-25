-- FIRST_VALUE
-- http://msdn.microsoft.com/en-us/library/hh213018(v=sql.110).aspx
-- Returns the first value in an ordered set of values

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
,   FIRST_VALUE(S.student) OVER (PARTITION BY S.affiliation ORDER BY S.score ASC) AS first_lowest_value
,   FIRST_VALUE(S.student) OVER (PARTITION BY S.affiliation ORDER BY S.score DESC) AS first_highest_value
,   FIRST_VALUE(S.student) OVER 
    (
        PARTITION BY S.affiliation ORDER BY S.score ASC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS best_of_the_rest   
FROM
    SRC S
ORDER BY
    4 DESC;