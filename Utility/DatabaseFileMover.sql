DECLARE
    @NewLogLocation varchar(256) = 'L:\SQLLog'
,   @NewBackupLocation varchar(256) = 'M:\SQLBackups'
,   @NewDataLocation varchar(256) = 'S:\SQLData'
,   @NewTempDBLocation varchar(256) = 'T:\TempDB'
,   @AlterCommand varchar(512) = '
ALTER DATABASE <dbname/> 
MODIFY FILE (NAME = <name/>, FILENAME = ''<new_location/>'');'
,   @MoveCommand varchar(512) = 'MOVE "<old_location/>" "<new_location/>"'
,   @DeleteCommand varchar(512) = 'DEL "<old_location/>"';

SELECT
    CASE
        WHEN D.type_desc = 'ROWS' AND D.DatabaseName <> 'tempdb' 
            -- Undo version
            -- THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', D.databaseName), '<name/>', D.LogicalName), '<new_location/>', D.PhysicalName)
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>', @NewDataLocation + '\' + D.BaseFileName)
        WHEN D.type_desc = 'LOG' AND D.DatabaseName <> 'tempdb' 
            -- Undo version
            -- THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', D.databaseName), '<name/>', D.LogicalName), '<new_location/>', D.PhysicalName)
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>', @NewLogLocation + '\' + D.BaseFileName)
        WHEN D.DatabaseName = 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>',  @NewTempDBLocation + '\' + D.BaseFileName)
        ELSE NULL
    END AS AlterCommand
,   CASE 
        WHEN D.type_desc = 'ROWS' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@MoveCommand, '<old_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<new_location/>', @NewDataLocation + '\' + D.BaseFileName)
        WHEN D.type_desc = 'LOG' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@MoveCommand, '<old_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<new_location/>', @NewLogLocation + '\' + D.BaseFileName)
        WHEN D.DatabaseName = 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@DeleteCommand, '<old_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<new_location/>', @NewLogLocation + '\' + D.BaseFileName)
    END AS MoveCommand
,   CASE
        WHEN D.type_desc = 'ROWS' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>', D.PhysicalName)
        WHEN D.type_desc = 'LOG' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>', D.PhysicalName)
        WHEN D.DatabaseName = 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@AlterCommand, '<dbname/>', QUOTENAME(D.databaseName)), '<name/>', D.LogicalName), '<new_location/>',  D.PhysicalName)
        ELSE NULL
    END AS UndoAlterCommand
,   CASE 
        WHEN D.type_desc = 'ROWS' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@MoveCommand, '<new_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<old_location/>', @NewDataLocation + '\' + D.BaseFileName)
        WHEN D.type_desc = 'LOG' AND D.DatabaseName <> 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@MoveCommand, '<new_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<old_location/>', @NewLogLocation + '\' + D.BaseFileName)
        WHEN D.DatabaseName = 'tempdb' 
            THEN REPLACE(REPLACE(REPLACE(@DeleteCommand, '<new_location/>', D.PhysicalName), '<name/>', D.LogicalName), '<old_location/>', @NewLogLocation + '\' + D.BaseFileName)
    END AS UndoMoveCommand
FROM
(
    SELECT D.*
    ,   LEFT(D.PhysicalName, D.LastSlash) AS CurrentFolder
    ,   RIGHT(D.PhysicalName, LEN(D.PhysicalName) - D.LastSlash - 1) AS BaseFileName
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
        --WHERE
        --    MF.database_id < 5
    ) D
) D
