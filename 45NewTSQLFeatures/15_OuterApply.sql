--OUTER APPLY
--http://technet.microsoft.com/en-us/library/ms175156.aspx
--Uses a table valued function for each row in outer query.  
--Similar to OUTER JOIN in that it always returns rows 
-- regardless of whether fn has rows

-- Generate 20 numbers in outer query, 
-- see that all outer rows exist
SELECT 
    A.number AS original
,   B.smallee AS cross_apply_results
FROM
    dbo.GenerateNumbers(20) AS A
    OUTER APPLY dbo.LessThan10(A.number) B