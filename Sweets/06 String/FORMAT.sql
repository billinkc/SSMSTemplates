-- FORMAT
-- http://msdn.microsoft.com/en-us/library/hh213505(v=sql.110).aspx
-- FORMAT does not do conversion, that's the domain of cast/convert/parse etc
-- Only accepts numeric and date/time data types for formatting. 
--
-- Formatting Types
-- http://msdn.microsoft.com/en-us/library/26etazsy.aspx

-- Standard numeric format strings
-- http://msdn.microsoft.com/en-us/library/dwhawy9k.aspx
SELECT
    -- c => currency
    FORMAT(1234.56, N'c', C.culture) AS zee_date
,   C.culture
FROM
    (
        -- Language culture names
        -- http://msdn.microsoft.com/en-us/library/ee825488(v=cs.20).aspx
        VALUES
            ('en-US')
        ,   ('en-GB')
        ,   ('ja-JP')
        ,   ('Ro-RO')
    ) C (culture);

-- Standard date format strings
-- http://msdn.microsoft.com/en-us/library/az4se3k1.aspx

SELECT
    -- F => Full date, long time specifier 
    FORMAT(CAST('2012-03-03' AS datetime), N'F', C.culture) AS zee_date
    -- s => Sortable date/time pattern (the crowd goes wild)
,   FORMAT(CAST('2012-03-03' AS datetime), N's', C.culture) AS sortable_date
,   C.culture
FROM
    (
        VALUES
            ('en-US')
        ,   ('en-GB')
        ,   ('ja-JP')
    ) C (culture);
    

-- Composite formatting is not an option, or is it?
--BOL states: The format argument must contain a valid .NET Framework format string, 
-- either as a standard format string (for example, "C" or "D"), or as a pattern of 
-- custom characters for dates and numeric values (for example, "MMMM dd, yyyy (dddd)"). 
-- Composite formatting is not supported. For a full explanation of these formatting 
-- patterns, please consult the.NET Framework documentation on string formatting in 
-- general, custom date and time formats, and custom number formats.
DECLARE @phoneNumber bigint = 9136488888
SELECT FORMAT( @phoneNumber, '###-###-####', 'en-US' ) AS phone_number;
