WITH GENERATE (number) AS
(
    SELECT CAST(0 AS smallint)
    UNION ALL
    SELECT CAST(G.number + 1 AS smallint)
    FROM
        GENERATE G
    WHERE
        G.number < 99
)
, X AS
(
SELECT
    CAST(dateadd(d, G.number, '2012-01-01') AS date) AS event_date
,   C.metric
,   CASE C.metric
        WHEN 'Hammer' THEN G.number * rand(G.number) * 10
        ELSE  550 - G.number * Rand() * 10
    END AS value
FROM
    GENERATE G
    CROSS APPLY
    (
        VALUES
        ('Hammer')
    ,   ('Saw')
    ) C (metric)
)
SELECT
    X.*
,   AVG(value) OVER(PARTITION BY X.metric ORDER BY X.event_date ASC)
,   AVG(value) OVER(PARTITION BY X.metric ORDER BY X.event_date ASC ROWS UNBOUNDED PRECEDING)
,   AVG(value) OVER(PARTITION BY X.metric ORDER BY X.event_date ASC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING)
,   AVG(value) OVER(PARTITION BY X.metric ORDER BY X.event_date ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW )
,   AVG(value) OVER(PARTITION BY X.metric ORDER BY X.event_date ASC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING )
FROM X