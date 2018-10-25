-- TRY_CONVERT
-- http://msdn.microsoft.com/en-us/library/hh230993(v=sql.110).aspx
-- Just a safe version of the existing CONVERT function

SELECT 
    TRY_CONVERT(varchar(12), CAST('2001-09-11' AS date), 107)

SELECT
    TRY_CONVERT(int, 'Penguins') AS safe_conversion_failure

SELECT
    TRY_CONVERT(varchar(12), CAST('2011-02-29' AS date), 107) AS bad_dates
