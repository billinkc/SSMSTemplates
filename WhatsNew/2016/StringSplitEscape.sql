SELECT
    P.[1] AS SourceSystem
,   P.[2] AS SourceId
,   P.[3] AS Value1
,   P.[4] AS EffectiveDate
,   P.[5] AS Value2
,   P.[6] AS Value3
FROM
(
    SELECT
        SS.value AS TextValue
    ,   ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS RN
    FROM
        (
            VALUES
            ('XYZ	86332	300000	2016-10-19	000615	000020')
        )First6(tabDelimited)
        CROSS APPLY
        STRING_SPLIT(First6.tabDelimited, CHAR(9)) AS SS
)D
PIVOT
(
    MIN(D.TextValue)
    FOR RN IN ([1],[2],[3],[4],[5],[6])
) P;

-- Convert to Text results (Ctrl-T)
SET NOCOUNT ON;
SELECT
    P.b
,   P.a
FROM
    ( VALUES (CONCAT('ABC', CHAR(10), 'x', CHAR(13), 'y', CHAR(9), 'tabs')))D(v)
    CROSS APPLY
    (
        SELECT 
            LEFT(STRING_ESCAPE(D.v, 'json'), 50), 'Escaped'
        UNION ALL
        SELECT
            LEFT(D.v, 50) , 'Orig'

    )P(a,b)
ORDER BY 1;