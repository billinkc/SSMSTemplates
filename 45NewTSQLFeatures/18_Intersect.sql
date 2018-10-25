-- INTERSECT
-- http://msdn.microsoft.com/en-us/library/ms188055.aspx
-- Gail Shaw, aka sqlinthewild has done performance work on INTERSECT vs INNER JOIN

DECLARE @Rolling20 TABLE
(
    number int
);

DECLARE @Ten20 TABLE
(
    number int
);

INSERT INTO
    @Rolling20
SELECT 
    * 
FROM 
    dbo.GenerateNumbers(20) AS GEN

INSERT INTO
    @Ten20
SELECT 
    * 
FROM 
    dbo.GenerateNumbers(20) AS GEN
WHERE
    GEN.number > 9

-- verify if you need to that we have 1-20
--SELECT R.* FROM @Rolling20 R 

-- verify if you need to that we have 10-20
--SELECT T.* FROM @Ten20 T

-- Show me everything in R that is not in T
SELECT
    *
FROM
    @Rolling20 R 
INTERSECT 
SELECT
    *
FROM
    @Ten20 T
