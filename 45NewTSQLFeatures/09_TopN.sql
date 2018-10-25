-- TOP N
-- The TOP operator is applied
--

-- TOP now accepts a variable
DECLARE @rowCount int;

SET @rowCount = 3;

SELECT TOP(@rowCount)
    DB.*
FROM
    sys.databases DB;
