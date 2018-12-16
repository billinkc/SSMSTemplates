SET NOCOUNT ON;
-- drop with extreme prejudice
IF EXISTS(SELECT * FROM sys.databases AS D WHERE D.name = 'DemoDb')
BEGIN
	ALTER DATABASE DemoDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DemoDb;
END
GO
DECLARE
	@mdfPath varchar(250) = (SELECT TOP 1  REPLACE(DF.physical_name, 'master.mdf', '') FROM sys.master_files AS DF WHERE DF.type = 0 AND DF.file_id = 1 AND database_id = 1)
,	@pathToken nvarchar(20) = '<DataPath/>'
,	@cmd nvarchar(max) = ''
,	@templateCreateDb nvarchar(max) = N'

CREATE DATABASE DemoDb CONTAINMENT = NONE
    ON PRIMARY
           (
               NAME = N''DemoDb''
           ,   FILENAME = N''<DataPath/>DemoDb.mdf''
           ,   SIZE = 8192KB
           ,   FILEGROWTH = 65536KB
           )
    LOG ON
        (
            NAME = N''DemoDb_log''
        ,   FILENAME = N''<DataPath/>DemoDb_log.ldf''
        ,   SIZE = 8192KB
        ,   FILEGROWTH = 65536KB
        );
';

	SELECT 
		@cmd = REPLACE(@templateCreateDb, @pathToken, @mdfPath);

	IF 1=1
	BEGIN
		PRINT @cmd
	END	
	EXECUTE sys.sp_executesql @cmd, N'';
GO
