SELECT
    D.*
,   LEFT(D.PhysicalName, D.LastSlash) AS CurrentFolder
,   RIGHT(D.PhysicalName, LEN(D.PhysicalName) - D.LastSlash - 1) AS FileName
FROM
(
    SELECT 
        name AS LogicalName
    ,   physical_name AS PhysicalName
    ,   LEN(MF.physical_name) - CHARINDEX('\', REVERSE(MF.physical_name)) AS LastSlash
    ,   MF.type_desc
    ,   DB_NAME(MF.database_id) AS DatabaseName
    ,   MF.database_id
    FROM 
        sys.master_files AS MF
    WHERE
        MF.database_id < 5
) D
