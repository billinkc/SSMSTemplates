-- PIVOT
-- Pivot makes many rows go into many columns
-- Painful, must know all possible values when query defined
-- unless you're Itzik
-- http://www.sqlmag.com/article/tsql3/pivot-on-steroids.aspx
-- http://www.kodyaz.com/articles/t-sql-pivot-tables-in-sql-server-tutorial-with-examples.aspx
-- http://msdn.microsoft.com/en-us/library/ms177410.aspx


DECLARE @survey table
(
    who varchar(20)
,   answer char(1)
)

INSERT INTO
    @survey

SELECT 'customer1', 'N'
UNION ALL SELECT 'customer1', 'Y'
UNION ALL SELECT 'customer2', 'N'
UNION ALL SELECT 'customer2', 'N'
UNION ALL SELECT 'customer3', 'Y'
UNION ALL SELECT 'customer3', 'Y'
UNION ALL SELECT 'customer3', 'Y'
UNION ALL SELECT 'customer3', 'Y'
UNION ALL SELECT 'customer3', 'Y'
UNION ALL SELECT 'customer3', 'Y'

SELECT
    *
FROM
    @survey T


-- How did they answer
-- Look at these columns from P, where did thos names
-- come from
SELECT
    P.who
,   P.Y
,   P.N
FROM
    @survey T
    PIVOT
    (
        count(answer)
        for answer in (Y, N)
    ) AS P

