-- Demonstrate the difference in plans between legacy moving average calculation and new
-- hotness
-- Turn on actual query plans
-- Run through and then rerun after removing filter and priming temp table
SET NOCOUNT ON;

IF object_id('tempdb..#SRC') IS NOT NULL
BEGIN
    DROP TABLE 
        #SRC 
END

CREATE TABLE 
    #SRC 
(
    event_date datetime
,   metric int
,   salesperson varchar(50)
-- I am gaming the demo by aligning my PK with the sort
,   PRIMARY KEY CLUSTERED (salesperson ASC, event_date ASC)
)
;

;WITH GENERATE (number) AS
(
    -- supplies us with 100 numbers
    SELECT CAST(0 AS smallint)
    UNION ALL
    SELECT CAST(G.number + 1 AS smallint)
    FROM
        GENERATE G
    WHERE
        G.number < 99
)
, GENERATE2(number) AS
(
    SELECT
        CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) -1 AS int)
    FROM
        -- 100 rows
        GENERATE G1
        -- 10000 rows (10k)
        CROSS APPLY
            GENERATE G2
        ---- 1000000 rows (1M)
        --CROSS APPLY
        --    GENERATE G3
)
, SRC (event_date, metric, salesperson) AS
(
    SELECT 
        DATEADD(d, G.number, DATEFROMPARTS(2012, 02, 1))
    ,   CASE D.sales_name
            WHEN 'Peter'
                THEN G.number * 2
            WHEN 'James'
                THEN - 1 * G.number 
            ELSE
                G.number
        END
    ,   D.sales_name
    FROM 
        GENERATE2 G
        CROSS APPLY
        (
            VALUES
                ('Peter')
            --,   ('Rufio')
            ,   ('James')

        ) D (sales_name)
    -- Comment this out to see a real performance difference
    WHERE
        G.number BETWEEN 0 and 10
)
INSERT INTO
    #SRC
SELECT 
    S.*
FROM 
    SRC S;



SET NOCOUNT ON;
SELECT 
    x.event_date
,   AVG(y.metric) moving_average
,   x.salesperson
FROM 
    #SRC x  
    INNER JOIN
        #SRC y
        ON y.salesperson = X.salesperson
WHERE 
    x.event_date >=  y.event_date
GROUP BY x.event_date, X.salesperson
ORDER BY 3,1;


SELECT 
    S.event_date
    -- These three are all the same, just illustrating implicit vs explicit options
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC) AS moving_average
--,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS UNBOUNDED PRECEDING) AS moving_average_explicit_start_implicit_stop
--,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average_explicit_start_stop
,   S.salesperson
FROM 
    #SRC S
ORDER BY
    3,1;
