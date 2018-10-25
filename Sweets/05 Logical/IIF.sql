-- IIF
-- http://msdn.microsoft.com/en-us/library/hh213574(v=sql.110).aspx
-- Simplified CASE statement
SELECT
    IIF(DATENAME(year, current_timestamp) = 2012, 'Ack Mayans', 'It''s not 2012, chill out honey bunny')
