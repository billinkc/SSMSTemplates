DECLARE @database_name sysname  
DECLARE
    @REPORT TABLE
(
    server_name sysname
,   database_name sysname
,   schemaname sysname
,   table_name sysname
,   row_counts bigint
)
    

DECLARE Csr CURSOR FORWARD_ONLY STATIC FOR  
SELECT DB.[name] 
FROM master.dbo.sysdatabases DB
WHERE DB.[name] NOT IN ('tempdb'
,'master'
,'model'
,'msdb'
,'ReportServer'
,'ReportServerTempDB'
)

DECLARE @queryTemplate nvarchar(max) = N'
USE <DB_NAME/>;
WITH OF_INTEREST AS
(
    SELECT DISTINCT 
        @@servername AS server_name
        , DB_NAME(DB_ID()) AS database_name
        , schema_name(T.schema_id) AS schemaname
        , OBJECT_NAME(I.object_id) AS table_name
    FROM SYS.INDEXES I
    INNER JOIN
        sys.tables T
        ON T.object_id = I.object_id
    WHERE INDEX_ID = 0
    AND OBJECTPROPERTY(I.object_id,''IsUserTable'') = 1
)
, RC AS
(
    SELECT
        s.[Name] as [SchemaName]
    ,   t.[name] as [TableName]
    ,   SUM(p.rows) as [RowCounts]
    FROM 
        sys.schemas s
        LEFT JOIN 
            sys.tables t
            ON s.schema_id = t.schema_id
        LEFT JOIN 
            sys.partitions p
            ON t.object_id = p.object_id
        LEFT JOIN  
            sys.allocation_units a
            ON p.partition_id = a.container_id
    WHERE 
        p.index_id  in(0,1) -- 0 heap table , 1 table with clustered index
        AND p.rows is not null
        AND a.type = 1  -- row-data only , not LOB
    GROUP BY 
        s.[Name]
    ,   t.[name]
)
SELECT
OI.*
, RC.RowCounts
FROM
OF_INTEREST OI
INNER JOIN
    RC
    ON RC.schemaname = OI.schemaname
    AND RC.tablename = OI.table_name
    
'
, @query nvarchar(max)


OPEN Csr  
FETCH NEXT FROM Csr INTO @database_name  
WHILE @@FETCH_STATUS = 0  
BEGIN

    SELECT @query = replace(@queryTemplate, '<DB_NAME/>', @database_name)
    BEGIN TRY
        INSERT INTO
            @REPORT
        EXECUTE (@query)
    END TRY
    BEGIN CATCH
        SELECT
            ERROR_NUMBER()AS error_number --returns the number of the error.
        ,   ERROR_SEVERITY() AS error_severity --returns the severity.
        ,   ERROR_STATE()AS error_state  --returns the error state number.
        ,   ERROR_PROCEDURE() AS error_procedure --returns the name of the stored procedure or trigger where the error occurred.
        ,   ERROR_LINE() AS error_line --returns the line number inside the routine that caused the error.
        ,   ERROR_MESSAGE() AS error_message --returns the complete text of the error message. The text includes the values supplied for any substitutable parameters, such as lengths, object names, or times.
    END CATCH

    FETCH NEXT FROM Csr INTO @database_name  
END  

CLOSE Csr  
DEALLOCATE Csr
;

SELECT * FROM @REPORT R;