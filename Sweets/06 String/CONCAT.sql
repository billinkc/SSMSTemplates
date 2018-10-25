-- CONCAT
-- http://msdn.microsoft.com/en-us/library/hh231515(v=sql.110).aspx
-- Adds strings together. Treats NULL like an empty string

SELECT
    CONCAT(1234, NULL, 456, 'foo') AS new_school
,   CAST(1234 AS varchar(12)) + COALESCE(NULL, '') + CAST(456 AS varchar(12)) + 'foo' AS oldschool

