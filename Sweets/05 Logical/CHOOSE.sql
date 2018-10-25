-- CHOOSE
-- http://msdn.microsoft.com/en-us/library/hh213019(v=sql.110).aspx
-- 1 based ordinal
-- Can use variables
-- Feels like it should have an array type but won't work with a table object

DECLARE
    @a char(1) = 'a'
,   @b char(1) = 'b'
,   @c char(1) = 'c'
,   @d char(1) = 'd'
,   @oneBasedOrdinal int = 2

SELECT
    CHOOSE(@oneBasedOrdinal, @a, @b, @c, @d) AS you_have_been_chosen
