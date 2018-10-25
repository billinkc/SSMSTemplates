-- TOP now accepts a variable
DECLARE @rowCount int;

SET @rowCount = 3;

SELECT TOP(@rowCount) PERCENT
    DB.*
FROM
    sys.databases DB
ORDER BY
    DB.collation_name;


-- with ties works for rows or percentages
SELECT TOP(@rowCount) PERCENT WITH TIES
    DB.*
FROM
    sys.databases DB
ORDER BY
    DB.collation_name;
