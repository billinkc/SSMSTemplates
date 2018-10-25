-- UNPIVOT
-- Make wide data into narrow but many rows
-- http://msdn.microsoft.com/en-us/library/ms177410.aspx
-- http://www.yafla.com/dennisforbes/UNPIVOT-Normalization-SQL-Server-2000-and-SQL-Server-2005/UNPIVOT-Normalization-SQL-Server-2000-and-SQL-Server-2005.html

-- data types must match, use CTE and explict casts to achieve this
DECLARE @surveyPivot table
(
    who varchar(20)
,   Y char(1)
,   N char(1)
)

INSERT INTO
    @surveyPivot

SELECT 'customer1', 1, 1
UNION ALL SELECT 'customer2', 0, 2
UNION ALL SELECT 'customer3', 6, 0
SELECT
    *
FROM
    @surveyPivot T


SELECT
    P.who
,   P.some_value
,   P.answer_column
FROM
    @surveyPivot T
    UNPIVOT
    (
        some_value
        for answer_column in (Y, N)
    ) AS P

