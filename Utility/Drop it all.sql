DECLARE CSR CURSOR
READ_ONLY
FOR 
-- Identify all the tables and views in the database
-- Only valid for SQL Server 2012+ as we use CONCAT
SELECT
    CONCAT('DROP VIEW ' , QUOTENAME(schema_name(V.schema_id)), '.', QUOTENAME(V.name), ';')
FROM
    sys.views AS V
UNION ALL
SELECT
    CONCAT('DROP TABLE ' , QUOTENAME(schema_name(T.schema_id)), '.', QUOTENAME(T.name), ';')
FROM
    sys.tables AS T
UNION ALL
SELECT
    CONCAT('DROP PROCEDURE ' , QUOTENAME(schema_name(P.schema_id)), '.', QUOTENAME(P.name), ';')
FROM
    sys.procedures AS P;


DECLARE @sql nvarchar(4000)
OPEN CSR

FETCH NEXT FROM CSR INTO @sql
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN
        BEGIN TRY
            -- blindly drop it
		    EXECUTE(@sql)
        END TRY
        BEGIN CATCH
            PRINT '/*Run again, the following statement failed */ ' + @sql
        END CATCH      
	END
	FETCH NEXT FROM CSR INTO @sql
END

CLOSE CSR
DEALLOCATE CSR
GO
