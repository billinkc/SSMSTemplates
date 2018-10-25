WITH SRC AS
(
    SELECT
        DB_NAME(MF.database_id) AS DatabaseName
    ,   MF.Name AS Logical_Name
    ,   (MF.size * 8) / 1024 SizeMB
    ,   MF.type_desc
    ,   MF.max_size
    ,   MF.growth
    ,   MF.is_percent_growth
    FROM
        sys.master_files AS MF
)
, SIZE_TYPE AS
(
    SELECT
        S.type_desc
    ,   SUM(S.SizeMB) AS TotalSizeMB
    FROM
        SRC S
    GROUP BY
        S.type_desc
)
SELECT
    S.DatabaseName
,   S.Logical_Name
,   S.SizeMB
,   S.type_desc
,   S.max_size
,   S.growth
,   S.is_percent_growth
,   ST.TotalSizeMB
FROM
    SRC AS S
    INNER JOIN
        SIZE_TYPE AS ST
        ON S.type_desc = ST.type_desc;