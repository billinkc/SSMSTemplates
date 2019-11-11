DECLARE
    @tableTemplate nvarchar(max) = N'
EXECUTE sys.sp_addextendedproperty
    @name = N''TableDocumentation''
,   @value = N''Placeholder''
,   @level0type = N''Schema''
,   @level0name = ''<Schema/>''
,   @level1type = N''Table''
,   @level1name = N''<Table/>'';
';

SELECT 
    REPLACE(REPLACE(@tableTemplate, '<Schema/>', S.name), '<Table/>', T.name)
,    S.name
,   T.name
FROM sys.schemas AS S
INNER JOIN sys.tables AS T
ON T.schema_id = S.schema_id
WHERE NOT EXISTS (SELECT * FROM sys.extended_properties AS EP WHERE EP.major_id = T.object_id)
ORDER BY
    S.name, T.name;



DECLARE
    @columnTemplate nvarchar(max) = N'
EXECUTE sys.sp_addextendedproperty
    @name = N''ColumnDocumentation''
,   @value = N''Placeholder''
,   @level0type = N''Schema''
,   @level0name = ''<Schema/>''
,   @level1type = N''Table''
,   @level1name = N''<Table/>''
,   @level2type = N''Column''
,   @level2name = N''<Column/>'';
';

SELECT 
    REPLACE(REPLACE(REPLACE(@columnTemplate, '<Schema/>', S.name), '<Table/>', T.name), '<Column/>', C.name)
,    S.name
,   T.name
,   C.name
FROM sys.schemas AS S
INNER JOIN sys.tables AS T
ON T.schema_id = S.schema_id
INNER JOIN sys.columns AS C
ON C.object_id = T.object_id
WHERE NOT EXISTS (SELECT * FROM sys.extended_properties AS EP WHERE EP.major_id = T.object_id AND EP.minor_id = C.column_id)
ORDER BY
    S.name, T.name, C.column_id;
