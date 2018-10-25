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
, SRC (event_date, metric, salesperson) AS
(
    SELECT 
        DATEFROMPARTS(2012, 02, G.number+1)
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
        GENERATE G
        CROSS APPLY
        (
            VALUES
                ('Peter')
            --,   ('Rufio')
            ,   ('James')

        ) D (sales_name)
    WHERE
        G.number BETWEEN 0 and 10
)
SELECT 
    S.*
    -- These three are all the same, just illustrating implicit vs explicit options
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC) AS moving_average
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS UNBOUNDED PRECEDING) AS moving_average_explicit_start_implicit_stop
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS moving_average_explicit_start_stop
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS average_of_current_row_and_next

,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS row_00
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS range_00
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS range_01
-- This is interesting. From BOL
-- The window frame "RANGE ... CURRENT ROW ..." includes all rows that have the same values in the ORDER BY expression as the current row
-- Without the partition by, the value generated is the average of all rows matching the order by key
-- 2012-02-07 values are -6 and 12  Average = 3
-- With the PARTITION BY, added in it becomes the average of the partition by, then order by. In our case, there is but one value 
,   AVG(S.metric) OVER(ORDER BY S.event_date ASC RANGE CURRENT ROW) AS CR
,   AVG(S.metric) OVER(PARTITION BY S.salesperson ORDER BY S.event_date ASC RANGE CURRENT ROW) AS CR
FROM 
    SRC S
ORDER BY
    3,1
