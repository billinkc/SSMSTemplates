WITH FKs AS
(
    -- Finds all the tables that serve as root
    SELECT
        S.name As SchemaName
    ,   S.schema_id
    ,   T.name AS TableName
    ,   T.object_id
    ,   C.name AS ColumnName
    ,   C.column_id 
    ,   I.name AS IndexName
    ,   I.index_id
    ,   CAST(0 AS int) AS TierId
    ,   CAST(NULL AS nvarchar(128)) AS ParentSchema
    ,   CAST(NULL AS nvarchar(128)) AS ParentTable
    ,   CAST(NULL AS nvarchar(128)) AS ParentColumn
    FROM
        sys.schemas AS S
        INNER JOIN
            sys.tables AS T
            ON S.schema_id = T.schema_id
        INNER JOIN
            sys.columns AS C
            ON C.object_id = T.object_id
        INNER JOIN
            sys.index_columns AS IC
            ON IC.column_id = C.column_id
            AND IC.object_id = T.object_id
        INNER JOIN
            sys.indexes AS I
            ON I.index_id = IC.index_id
            AND I.object_id = T.object_id
    WHERE
        T.object_id NOT IN (SELECT FK.object_id FROM sys.foreign_keys AS FK)
        AND I.is_primary_key = 1

    UNION ALL
    SELECT
        S.name As SchemaName
    ,   S.schema_id
    ,   T.name AS TableName
    ,   T.object_id
    ,   C.name AS ColumnName
    ,   C.column_id 
    ,   I.name AS IndexName
    ,   I.index_id
    ,   REF.TierId +1  AS TierId
    ,   REF.SchemaName AS ParentSchema
    ,   REF.TableName AS ParentTable
    ,   REF.ColumnName AS ParentColumn
    FROM
        sys.schemas AS S
        INNER JOIN
            sys.tables AS T
            ON S.schema_id = T.schema_id
        INNER JOIN
            sys.columns AS C
            ON C.object_id = T.object_id
        INNER JOIN
            sys.index_columns AS IC
            ON IC.column_id = C.column_id
            AND IC.object_id = T.object_id
        INNER JOIN
            sys.indexes AS I
            ON I.index_id = IC.index_id
            AND I.object_id = T.object_id
        INNER JOIN
            sys.foreign_key_columns AS FKC
            ON FKC.parent_object_id = T.object_id
            AND FKC.parent_column_id = C.column_id
        INNER JOIN
            FKs AS REF
            ON FKC.referenced_object_id = REF.object_id
            AND FKC.referenced_column_id = REF.column_id
        --INNER JOIN
        --    FKs AS REF
        --    ON REF.
    --WHERE
    --    S.name = 'dbo'
    --    AND T.name = 'FINANCIALTRANSACTION'
    --    AND I.is_primary_key = 1

)

SELECT * 
FROM
    FKs
