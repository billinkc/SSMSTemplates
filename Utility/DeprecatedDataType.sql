SELECT
	SCHEMA_NAME(ST.schema_id) AS [Schema]
,	ST.name AS TableName
,	SC.name AS ColumnName
,	TT.name AS DeprecatedDataType
FROM
	sys.columns AS SC
	INNER JOIN
		sys.tables AS ST
		ON ST.object_id = SC.object_id
	INNER JOIN
		sys.types As TT
		ON TT.system_type_id = SC.system_type_id
WHERE
	TT.name IN ('image', 'text', 'ntext');
