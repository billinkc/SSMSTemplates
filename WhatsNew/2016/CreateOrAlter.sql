USE DemoDb;
SELECT * FROM sys.schemas AS S INNER JOIN sys.views AS V ON V.schema_id = S.schema_id WHERE V.name = 'MyView';
GO
CREATE OR ALTER VIEW dbo.MyView AS SELECT 1 AS x;
GO
CREATE OR ALTER VIEW dbo.MyView AS SELECT 2 AS x;
GO
SELECT * FROM dbo.MyView