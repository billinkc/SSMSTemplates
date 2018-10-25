USE DemoDb

IF NOT EXISTS(
SELECT * FROM sys.filegroups AS F WHERE F.name = 'FGSelectInto'
)
BEGIN
    ALTER DATABASE DemoDb
    ADD FILEGROUP FGSelectInto;

    DECLARE
        @mdfPath varchar(250) = (SELECT REPLACE(DF.physical_name, 'DemoDb.mdf', '') FROM sys.database_files AS DF WHERE DF.type = 0 AND DF.file_id = 1);
    DECLARE
        @cheapHack nvarchar(max) = N'ALTER DATABASE DemoDb ADD FILE (NAME=''FGSelectInto_Data'',FILENAME='''
    + @mdfPath + 'SelectIntDemo.ndf'' ) TO FILEGROUP FGSelectInto;'

    EXECUTE sys.sp_executesql @cheapHack, N'';
END

DROP TABLE IF EXISTS dbo.DefaultFileGroup;

SELECT 'Old' AS SomeCol
INTO
    dbo.DefaultFileGroup;

DROP TABLE IF EXISTS dbo.SelectIntoOnFileGroup;
SELECT
    2017 AS AvailableIn
INTO
    dbo.SelectIntoOnFileGroup
ON FGSelectInto;

-- Prove it!
SELECT
    S.name AS SchemaName
,   T.name AS TableName
,   DS.name AS FileGroupName
,   T.create_date AS TableCreateDate
FROM
    sys.schemas AS S
    INNER JOIN
        sys.tables AS T
        ON T.schema_id = S.schema_id
    INNER JOIN
        sys.indexes AS I
        ON I.object_id = T.object_id
    INNER JOIN
        sys.data_spaces AS DS
        ON DS.data_space_id = I.data_space_id
    INNER JOIN
        sys.partitions AS P
        ON P.object_id = T.object_id
WHERE
    S.name = 'dbo'
    AND T.name IN
    (
        'SelectIntoOnFileGroup'
    ,   'PRIMARY'
    );

