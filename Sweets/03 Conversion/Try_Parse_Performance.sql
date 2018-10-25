SET NOCOUNT ON

DECLARE
    @parse_start time
,   @parse_stop time
,   @cast_start time
,   @cast_stop time

DECLARE
    @SPEEDTEST TABLE
(
    number bigint PRIMARY KEY
,   source varchar(10) NOT NULL
)

; WITH GENERATE (number) AS
(
    SELECT CAST(0 AS smallint)
    UNION ALL
    SELECT CAST(G.number + 1 AS smallint)
    FROM
        GENERATE G
    WHERE
        G.number < 99
)
, EXPLODE (number) AS
(
    SELECT 
         G.number
    FROM 
        -- 100 rows
        GENERATE G
        -- 10,000 rows
        CROSS APPLY
            GENERATE G2
        -- 1,000,000 rows
        CROSS APPLY
            GENERATE G3
)
, SOURCE (number) AS
(
    SELECT
         ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM 
        EXPLODE E
)
INSERT INTO
    @SPEEDTEST
SELECT
    S.number
,   CAST(S.number AS varchar(10)) AS source
FROM
    SOURCE S

SELECT
    @parse_start = CURRENT_TIMESTAMP

SELECT
    TRY_PARSE(T.source AS int) AS foo
FROM
    @SPEEDTEST T

SELECT
    @parse_stop = CURRENT_TIMESTAMP


SELECT
    @cast_start = CURRENT_TIMESTAMP

SELECT
    CAST(T.source AS int) AS foo
FROM
    @SPEEDTEST T

SELECT
   @cast_stop = CURRENT_TIMESTAMP

-- Takes ~1 minute on my laptop
PRINT 'Duration of try_parse delta in milliseconds'
PRINT datediff(MILLISECOND, @parse_start, @parse_stop)
PRINT ''
PRINT 'Duration of cast delta in milliseconds'
PRINT datediff(MILLISECOND, @cast_start, @cast_stop) 
PRINT ''
PRINT 'TRY_PARSE is slower than CAST by a factor of ' 
    + CAST(datediff(MILLISECOND, @parse_start, @parse_stop) / (datediff(MILLISECOND, @cast_start, @cast_stop)) AS varchar(10))
