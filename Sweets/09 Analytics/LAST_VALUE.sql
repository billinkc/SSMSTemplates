-- LAST_VALUE
-- http://msdn.microsoft.com/en-us/library/hh231517(v=sql.110).aspx
-- Returns the last value in an ordered set of values
-- See also
-- http://connect.microsoft.com/SQLServer/feedback/details/679668/last-value-does-not-return-expected-values
--The behavior you are seeing is by design and according to the ANSI SQL specification. 
--Basically the rule is that if window frame is not specified then the default is 
--RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW or RANGE UNBOUNDED PRECEDING. 
--So in case of LAST_VALUE, you will always get CURRENT ROW if the frame is omitted. To 
--get the expected results, you need to specify the entire frame. See below for examples:

--select Id
--     , val
--     , Last_Value(val) OVER (Order By Id) as LV1_CURRENT_ROW
--     , Last_Value(val) OVER (Order By Id range unbounded preceding) as LV2_CURRENT_ROW
--     , Last_Value(val) OVER (Order By Id range between unbounded preceding and current row) as LV3_CURRENT_ROW
--     , Last_Value(val) OVER (Order By Id rows between unbounded preceding and unbounded following) as LV3_LAST_ROW_BY_ROWS
--     , Last_Value(val) OVER (Order By Id range between unbounded preceding and unbounded following) as LV3_LAST_ROW_BY_RANGE
-- from (Values (1, 1),(2, 2),(3, 3), (4, 4) ) as t(Id, val)

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
,   LAST_VALUE(S.student) OVER (PARTITION BY S.affiliation ORDER BY S.score ASC) AS first_lowest_value
,   LAST_VALUE(S.student) OVER (PARTITION BY S.affiliation ORDER BY S.score DESC) AS first_highest_value
,   LAST_VALUE(S.student) OVER 
    (
        PARTITION BY S.affiliation ORDER BY S.score ASC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
    ) AS best_of_the_rest   
FROM
    SRC S
ORDER BY
    1 DESC;