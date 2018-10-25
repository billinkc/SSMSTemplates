
-- Lengthy unicode stuff below
DECLARE @unicode nvarchar(max)

SET @unicode = REPLICATE('¥', 8000)
SET @unicode = @unicode + @unicode + @unicode
SELECT len(@unicode) AS len_unicode, @unicode as unicode_stuff