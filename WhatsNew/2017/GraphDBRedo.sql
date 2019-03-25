--CREATE SCHEMA ETL AUTHORIZATION dbo;

DROP TABLE IF EXISTS ETL.PackageDependency;
DROP TABLE IF EXISTS ETL.PackageDependencyNode;
DROP TABLE IF EXISTS ETL.PackageNode;
DROP TABLE IF EXISTS ETL.PackageEdge;


CREATE TABLE ETL.PackageDependency
(
    MasterPackageName sysname NOT NULL
,   ContainerName sysname NOT NULL
,   ChildPackageName sysname NOT NULL
,   ExecutionOrderNumber int NOT NULL
,   RefreshThresholdMinutes int NOT NULL
,   CONSTRAINT PK_ETL_PackageDependency PRIMARY KEY CLUSTERED 
    (
        MasterPackageName ASC
    ,   ContainerName ASC
    ,   ChildPackageName ASC
    )
);


CREATE TABLE ETL.PackageNode
(
    -- Folder name
    -- project name
    PackageName sysname NOT NULL
,   CONSTRAINT PK_ETL_PackageNode PRIMARY KEY CLUSTERED 
    (
        PackageName ASC
    --,   ContainerName ASC
    --,   ChildPackageName ASC
    )
) AS NODE;

CREATE TABLE ETL.PackageEdge
(
    ContainerName sysname NOT NULL
,   ExecutionOrderNumber int NOT NULL
,   RefreshThresholdMinutes int NOT NULL

) AS EDGE;


INSERT INTO ETL.PackageDependency
(MasterPackageName, ContainerName, ChildPackageName, ExecutionOrderNumber, RefreshThresholdMinutes)
VALUES
    ('MasterStaging', 'Container_0', 'StageSlowPackage',  0, 24*60)
,   ('MasterStaging', 'Container_1', 'StageFastPackage00',  0, 24*60)
,   ('MasterStaging', 'Container_1', 'StageFastPackage10',  10, 24*60)
,   ('MasterStaging', 'Container_1', 'StageFastPackage20',  20, 12*60)
,   ('MasterDimensions', 'Container_0', 'MasterStaging',  0, 12*60)
,   ('MasterDimensions', 'Container_0', 'DimensionProcessing',  10, 12*60)
;

INSERT INTO
    ETL.PackageNode
(
    PackageName
)
SELECT
    PD.MasterPackageName
FROM
    ETL.PackageDependency AS PD
union
SELECT
    PD.ChildPackageName
FROM
    ETL.PackageDependency AS PD;

INSERT INTO
    ETL.PackageEdge 
SELECT
	-- This is special as heck, don't wrap with square brackets
	M.$node_id AS from_id
,	C.$node_id AS to_id
,   PD.ContainerName
,   PD.ExecutionOrderNumber
,   PD.RefreshThresholdMinutes
FROM
	ETL.PackageDependency AS PD
    INNER JOIN
        ETL.PackageNode AS M
        ON M.PackageName = PD.MasterPackageName
    INNER JOIN
        ETL.PackageNode AS C
        ON C.PackageName = PD.ChildPackageName;

/*
SELECT
    M.PackageName AS MasterPackageName
,   E.ContainerName
,   C.PackageName AS ChildPackageName
,   E.ExecutionOrderNumber
,   E.RefreshThresholdMinutes
FROM
    ETL.PackageNode AS M
    ,   ETL.PackageEdge AS E
    ,   ETL.PackageNode AS C
WHERE
    MATCH(M-(E)->C);

SELECT * FROM ETL.PackageDependency AS PD;
*/

-- What SSIS packages still need to run?
/*
EXECUTE ETL.PackageProcesssingControlListGet 'MasterDimensions', 'Container_0', 24;
EXECUTE ETL.PackageProcesssingControlListGet 'MasterStaging', 'Container_0', 24;
EXECUTE ETL.PackageProcesssingControlListGet 'MasterStaging', 'Container_1', 24;
*/
EXECUTE ETL.PackageProcesssingControlListGet 'MasterStaging', 'Container_1', 24;

SELECT
/*
    M.PackageName AS MasterPackageName
,   E.ContainerName
,   C.PackageName AS ChildPackageName
,   E.ExecutionOrderNumber
,   E.RefreshThresholdMinutes
*/
    CONCAT(C.PackageName, '.dtsx') AS ChildPackageName
FROM
    ETL.PackageNode AS M
    ,   ETL.PackageEdge AS E
    ,   ETL.PackageNode AS C
WHERE
    MATCH(M-(E)->C)
    AND M.PackageName = 'MasterStaging'
    AND E.ContainerName = 'Container_1'
    AND NOT EXISTS
    (
    SELECT * FROM ETL.PackageControl AS PC WHERE PC.StopTime IS NOT NULL
    AND PC.PackageName = C.PackageName
    AND PC.StartTime > dateadd(hour, -1 * 24*60, CURRENT_TIMESTAMP)
    )
ORDER BY 1;

/*
        SELECT
            CONCAT(PD.ChildPackageName, '.dtsx') As ChildPackageName
        FROM
            ETL.PackageDependency AS PD
            LEFT OUTER JOIN
                -- Find packages that have not completed
                ETL.PackageControl AS PC
                ON PC.PackageName = PD.ChildPackageName
                AND PC.StartTime > dateadd(hour, -1 * @RefreshThreshold, CURRENT_TIMESTAMP)
                -- StopTime is only populated when package completes successfully
                AND PC.StopTime IS NOT NULL
        WHERE
            PD.MasterPackageName = @MasterPackageName
            AND PD.ContainerName = @ContainerName 
            AND PC.PackageName IS NULL
        ORDER BY 
            PD.ExecutionOrderNumber ASC;
*/
