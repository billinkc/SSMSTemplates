---------------------------------------------------------------------
-- A script for finding errors captured via extended event
---------------------------------------------------------------------
IF OBJECT_ID('tempdb..#EEC') IS NOT NULL
BEGIN
    DROP TABLE #EEC;
END

SELECT * 
INTO
    #EEC
FROM master.dbo.errorCapture AS EC 

SELECT 
    E.*, D.name 
FROM #EEC AS E
INNER JOIN sys.databases AS D ON D.database_id = E.database_id
WHERE 
1=1
-- SQLPrompt/SSMS intellisense garbage error
AND E.err_message NOT IN('Cannot drop the table ''#SVer'', because it does not exist or you do not have permission.')
AND E.err_number NOT IN( 9104 /* auto statistics internal */, 25721 /* The metadata file name "%s" is invalid...*/, 1205 /*deadlock victim*/)
ORDER BY 1 DESC;