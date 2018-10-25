-- drop with extreme prejudice
IF EXISTS(SELECT * FROM sys.databases AS D WHERE D.name = 'DemoDb')
BEGIN
	ALTER DATABASE DemoDb SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DemoDb;
END
go
CREATE DATABASE DemoDb CONTAINMENT = NONE
    ON PRIMARY
           (
               NAME = N'DemoDb'
           ,   FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.DEV2017\MSSQL\DATA\DemoDb.mdf'
           ,   SIZE = 8192KB
           ,   FILEGROWTH = 65536KB
           )
    LOG ON
        (
            NAME = N'DemoDb_log'
        ,   FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.DEV2017\MSSQL\DATA\DemoDb_log.ldf'
        ,   SIZE = 8192KB
        ,   FILEGROWTH = 65536KB
        );
GO