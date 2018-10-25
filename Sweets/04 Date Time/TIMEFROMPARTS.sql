-- TIMEFROMPARTS
-- http://msdn.microsoft.com/en-us/library/hh213398(v=sql.110).aspx

-- Generate all the possible time values for hours, minutes and seconds
;
WITH L0 AS
    (
        SELECT
            0 AS C
        UNION ALL
        SELECT
            0
    )
    , L1 AS
    (
        SELECT
            0 AS c
        FROM
            L0 AS A
            CROSS JOIN L0 AS B
    )
    , L2 AS
    (
        SELECT
            0 AS c
        FROM
            L1 AS A
            CROSS JOIN L1 AS B
    )
    , L3 AS
    (
        SELECT
            0 AS c
        FROM
            L2 AS A
            CROSS JOIN L2 AS B
    )
    , L4 AS
    (
        SELECT
            0 AS c
        FROM
            L3 AS A
            CROSS JOIN L3 AS B
    )
    , L5 AS
    (
        SELECT
            0 AS c
        FROM
            L4 AS A
            CROSS JOIN L4 AS B
    )
    , NUMS AS
    (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS number
        FROM
            L5
    )
,   TWENTY_FOUR (number) AS
(
    SELECT top (24)
        number -1
    FROM
        NUMS
    ORDER BY
        number
)
,   SIXTY (number) AS
(
    SELECT top (60)
        number -1
    FROM
        NUMS
    ORDER BY
        number
)
, SOURCE AS
(
SELECT 
    H.number AS hour_int
,   M.number AS minute_int
,   S.number AS second_int
FROM
    TWENTY_FOUR H
    CROSS JOIN
        SIXTY M
    CROSS JOIN
        SIXTY S
)
--TimeSK	Time	Hour	MilitaryHour	Minute	Second	AmPm	StandardTime
SELECT
    ROW_NUMBER() OVER (ORDER BY S.hour_int ASC, S.minute_int ASC, S.second_int ASC) AS TimeSK
,   TIMEFROMPARTS(S.HOUR_int, S.minute_int, S.second_int, 0, 0) AS [Time]
    -- the remainder could be improved with the use of FORMAT
,   RIGHT('0' + CAST(IIF(S.hour_int % 12 = 0, 12, S.hour_int % 12) AS varchar(2)), 2) AS [Hour]
,   RIGHT('0' + CAST(S.hour_int  AS varchar(2)), 2) AS [MilitaryHour]
,   RIGHT('0' + CAST(S.minute_int  AS varchar(2)), 2) AS [Minute]
,   RIGHT('0' + CAST(S.second_int  AS varchar(2)), 2) AS [Second]
,   CASE WHEN S.hour_int > 11 THEN 'PM' ELSE 'AM' END AS [AmPm]
,   CAST(TIMEFROMPARTS(IIF(S.hour_int % 12 = 0, 12, S.hour_int % 12), S.minute_int, S.second_int, 0, 0) AS char(8)) + CASE WHEN S.hour_int > 11 THEN ' PM' ELSE ' AM' END AS [StandardTime]

FROM
    SOURCE S
ORDER BY
    S.hour_int ASC
,   S.minute_int ASC
,   S.second_int ASC