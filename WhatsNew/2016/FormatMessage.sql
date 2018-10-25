-- FORMATMESSAGE
SELECT
    D.v
,   FORMATMESSAGE(FM.fmt, D.v) AS Formatted
,   FM.fmt_desc
,   FM.fmt
FROM
    (SELECT 16) D(v)
    CROSS APPLY
    (
        SELECT
            *
        FROM
        (
            VALUES 
                ('%i', 'integer')
            ,   ('%u', 'unsigned integer')
            ,   ('%o', 'unsigned octal')
            ,   ('%x', 'unsigned hex')

            ,   ('%#o', 'unsigned octal with prefix')
            ,   ('%#x', 'unsigned hex with prefix')
            ,   ('%#06x', 'unsigned hex with prefix and width (leading 0x included)')
            -- Leading zero required
            ,   ('%010i', 'integer, length 10, aka leading zeroes')
            ,   ('%020i', 'integer, length 20, aka leading zeroes')

        ) F(fmt, fmt_desc)
    )FM;



SELECT
    D.v
,   FORMATMESSAGE(FM.fmt, D.v) AS Formatted
,   FM.fmt_desc
,   FM.fmt
FROM
    (SELECT '16') D(v)
    CROSS APPLY
    (
        SELECT
            *
        FROM
        (
            VALUES 
            -- Requires source type to match format string
                ('%s', 'string')
            ,   ('%-20s', 'string 30 wide, left justified')
            ,   ('%20s', 'string 30 wide, right justified')
            ,   ('%s ' + REPLICATE('X', 2047), '2047 max length - ish')
        ) F(fmt, fmt_desc)
    )FM;



