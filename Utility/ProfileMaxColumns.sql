-- An approach for data profiling all the table values defined as n/varchar(max)
-- Dirty all the reads
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;

DROP TABLE IF EXISTS ##ColumnProfiling;
CREATE TABLE ##ColumnProfiling
(
	SchemaName sysname
,	TableName sysname
,	ColumnName sysname
,	ColumnLength int
,	IsNullable bit
);


-- It's a cursor, get over it
DECLARE CSR CURSOR LOCAL
FAST_FORWARD
FOR
SELECT
	CONCAT
	(
	'INSERT INTO ##ColumnProfiling SELECT ''' 
	,	S.name
	,	''' AS SchemaName'
	,	', '''
	,	T.name
	,	''' AS TableName'
	,	', '''
	,	C.name
	,	''' As ColumnName'
	,	', LEN('
	,	C.name
	,	') AS ColumnLength '
	,	', CASE WHEN '
	,	C.name
	,	' IS NULL THEN 1 ELSE 0 END AS IsNullable '
	,	' FROM '
	,	S.name
	,	'.'
	,	T.name
	,	';'
	)
FROM
	sys.schemas AS S
	INNER JOIN 
		sys.tables AS T
		ON S.schema_id = T.schema_id
	INNER JOIN
		sys.columns AS C
		ON C.object_id = T.object_id
WHERE
	C.max_length = -1
	AND EXISTS (SELECT * FROM sys.types AS TT WHERE TT.name in ('nvarchar', 'varchar') AND TT.user_type_id = C.user_type_id)
ORDER BY
	S.name
,	T.name
,	C.column_id;

DECLARE @Query nvarchar(4000);
OPEN CSR;
FETCH NEXT FROM CSR INTO @Query;
WHILE @@FETCH_STATUS = 0
BEGIN
	BEGIN TRY
		EXECUTE sys.sp_executesql @query;
	END TRY
	BEGIN CATCH
		PRINT 'Something bad happened ';
		PRINT error_message();
		PRINT @query;
		PRINT '';
	END CATCH

	FETCH NEXT FROM CSR INTO @Query;
END
CLOSE CSR;
DEALLOCATE CSR;

-- Post processing anlaysis
SELECT
	CP.SchemaName
,	CP.TableName
,	CP.ColumnName
,	MIN(CP.ColumnLength) As MinColumnLength
,	AVG(CP.ColumnLength) AS AvgColumnLength
,	MAX(CP.ColumnLength) AS MaxColumnLength
,	STDEV(CP.ColumnLength) As StDColumnLength
,	MAX(CAST(CP.IsNullable AS tinyint)) AS IsNullable
,	COUNT_BIG(CP.ColumnLength) AS RowsWithData
FROM
	##ColumnProfiling AS CP
GROUP BY
	CP.SchemaName
,	CP.TableName
,	CP.ColumnName;
