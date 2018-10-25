SELECT
	S.name AS SchemaName
,	T.name AS TableName
,	STUFF
	(
		(
			SELECT ',' + C.name
			FROM sys.columns AS C
			WHERE C.object_id = T.object_id
			ORDER BY C.column_id
			FOR XML PATH('')
		)
	,	1
	,   1
	,	''
	) AS ColumnList
FROM
	sys.schemas AS S
	INNER JOIN
		sys.tables AS T
		ON T.schema_id = S.schema_id;

SELECT
	S.name AS SchemaName
,	T.name AS TableName
,	STRING_AGG(C.name, ',')
	WITHIN GROUP (ORDER BY C.column_id) AS ColumnList
FROM
	sys.schemas AS S
	INNER JOIN
		sys.tables AS T
		ON T.schema_id = S.schema_id
	INNER JOIN
		sys.columns AS C
		ON C.object_id = T.object_id
GROUP BY
	S.name
,	T.name;				