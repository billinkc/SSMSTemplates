-- LEAD
-- http://msdn.microsoft.com/en-us/library/hh213125(v=sql.110).aspx 
-- Accesses data from a subsequent row in the same result set without the 
-- use of a self-join in Microsoft SQL Server 2012 Release Candidate 0 (RC 0). 
-- LEAD provides access to a row at a given physical offset that follows 
-- the current row. Use this analytic function in a SELECT statement to compare 
-- values in the current row with values in a following row.

-- LAG
-- http://msdn.microsoft.com/en-us/library/hh231256(v=sql.110).aspx 
-- Accesses data from a previous row in the same result set without the 
-- use of a self-join in Microsoft SQL Server 2012 Release Candidate 0 (RC 0). 
-- LAG provides access to a row at a given physical offset that comes before 
-- the current row. Use this analytic function in a SELECT statement to compare
-- values in the current row with values in a previous row.

DECLARE
    @default int = -99999
,   @offset int = 2;

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
,   LEAD(metric, @offset, @default) OVER(PARTITION BY S.salesperson ORDER BY S.event_date) AS LeadingMetric
,   LAG(metric, @offset, @default) OVER(PARTITION BY S.salesperson ORDER BY S.event_date) AS LaggingMetric

FROM
    SRC S;