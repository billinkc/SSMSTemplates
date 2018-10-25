-- TODO Figure out the values here
SELECT
    fi.avg_fragmentation_in_percent AS [AverageFragmentation]
FROM
    sys.tables AS tbl
    INNER JOIN sys.indexes AS i
    ON (
        i.index_id > @_msparam_0
        AND i.is_hypothetical = @_msparam_1
       )
       AND (i.object_id = tbl.object_id)
    INNER JOIN sys.dm_db_index_physical_stats(@database_id, NULL, NULL, NULL,
                                              'LIMITED') AS fi
    ON fi.object_id = CAST(i.object_id AS int)
       AND fi.index_id = CAST(i.index_id AS int)
WHERE
    (i.name = @_msparam_2)
    AND (
         (tbl.name = @_msparam_3
         AND SCHEMA_NAME(tbl.schema_id) = @_msparam_4)
        )