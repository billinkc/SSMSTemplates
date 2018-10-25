-- DATABASE SNAPSHOT
-- http://msdn.microsoft.com/en-us/library/ms175158.aspx
-- http://msdn.microsoft.com/en-us/library/ms175876.aspx


DECLARE @sql nvarchar(max)
,  @databaseName sysname

SET @databaseName = 'FOURTY_FIVE';

SELECT
    @sql = 'CREATE DATABASE ' + DB.name + '_snapshot ON ' + char(10)
    + '(   NAME = ' + MF.name + char(10) + ',   FILENAME = ''' + replace(MF.physical_name, '.mdf', '.snapshot')
    + '''' + char(10)+ ')' + char(10) + '    AS SNAPSHOT OF ' + DB.name
FROM
    sys.master_files MF
    INNER JOIN
        sys.databases DB
        ON DB.database_id = MF.database_id
WHERE
    MF.data_space_id = 1
    AND MF.type_desc = 'ROWS'
    AND DB.name = @databaseName

PRINT @sql

EXECUTE(@sql)

/*
CREATE DATABASE FOURTY_FIVE_snapshot ON
(   NAME = FOURTY_FIVE
,   FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL.2\MSSQL\DATA\FOURTY_FIVE.snapshot'
)
    AS SNAPSHOT OF FOURTY_FIVE
Msg 911, Level 16, State 1, Line 19
Could not locate entry in sysdatabases for database 'CREATE DATABASE FOURTY_FIVE_snapshot ON
(   NAME = FOURTY_FIVE
,   FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL'. No entry found with that name. Make sure that the name is entered correctly.
*/


-- At this point, we've created a copy of the FOURTY_FIVE database

SELECT * FROM FOURTY_FIVE.dbo.authors
SELECT * FROM FOURTY_FIVE_snapshot.dbo.authors

INSERT INTO
    FOURTY_FIVE.dbo.authors
SELECT
    'Charles' AS name_first
,   'Dickens' AS name_last

SELECT * FROM FOURTY_FIVE.dbo.authors
SELECT * FROM FOURTY_FIVE_snapshot.dbo.authors

INSERT INTO
    FOURTY_FIVE_snapshot.dbo.authors
SELECT
    'Charles' AS name_first
,   'Dockens' AS name_last

--Msg 3906, Level 16, State 1, Line 1
--Failed to update database "FOURTY_FIVE_snapshot" because the database is read-only.

backup log FOURTY_FIVE with no_log
checkpoint
use master
go
-- 7 seconds
RESTORE DATABASE FOURTY_FIVE FROM DATABASE_SNAPSHOT = 'FOURTY_FIVE_snapshot'

BEGIN TRAN
INSERT INTO
    FOURTY_FIVE.dbo.authors
SELECT
    'Charles' AS name_first
,   'Dockens' AS name_last

ROLLBACK
-- note the increase in identity value
INSERT INTO
    FOURTY_FIVE.dbo.authors
SELECT
    'Charles' AS name_first
,   'Duckens' AS name_last

GO


