--CROSS APPLY
--http://technet.microsoft.com/en-us/library/ms175156.aspx
--Uses a table valued function for each row in outer query.  
--Similar to INNER JOIN in that only returns rows if fn has rows

-- Generate 20 numbers in outer query, 
-- see that only the matches are returned
SELECT 
    A.number AS original
,   B.smallee AS cross_apply_results
FROM
    dbo.GenerateNumbers(20) AS A
    CROSS APPLY dbo.LessThan10(A.number) B


select * FROM dbo.LessThan10(10)
