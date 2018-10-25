USE DemoDb;

DECLARE
	@DemoParallelInsertPerformance char(1) = 'N';

IF EXISTS (SELECT * FROM sys.schemas AS S INNER JOIN sys.tables AS T ON T.schema_id = S.schema_id WHERE S.name = 'dbo' AND T.name = 'FactRowDemo')
BEGIN
	DROP TABLE dbo.FactRowDemo;
END
IF EXISTS (SELECT * FROM sys.schemas AS S INNER JOIN sys.tables AS T ON T.schema_id = S.schema_id WHERE S.name = 'dbo' AND T.name = 'FactDemoRowCompressed')
BEGIN
	DROP TABLE dbo.FactDemoRowCompressed;
END
IF EXISTS (SELECT * FROM sys.schemas AS S INNER JOIN sys.tables AS T ON T.schema_id = S.schema_id WHERE S.name = 'dbo' AND T.name = 'FactDemoPageCompressed')
BEGIN
	DROP TABLE dbo.FactDemoPageCompressed;
END
IF EXISTS (SELECT * FROM sys.schemas AS S INNER JOIN sys.tables AS T ON T.schema_id = S.schema_id WHERE S.name = 'dbo' AND T.name = 'FactCCIDemo')
BEGIN
	DROP TABLE dbo.FactCCIDemo;
END

IF @DemoParallelInsertPerformance = 'N'
BEGIN
	CREATE TABLE
		dbo.FactRowDemo
	(
		SalesDateSk int NOT NULL
	,	CustomerSk int NOT NULL
	,	ProductSk int NOT NULL
	,	Quantity int NOT NULL 
	) WITH	(DATA_COMPRESSION =NONE);
END

CREATE TABLE
	dbo.FactDemoRowCompressed
(
	SalesDateSk int NOT NULL
,	CustomerSk int NOT NULL
,	ProductSk int NOT NULL
,	Quantity int NOT NULL 
) WITH	(DATA_COMPRESSION =ROW);

CREATE TABLE
	dbo.FactDemoPageCompressed
(
	SalesDateSk int NOT NULL
,	CustomerSk int NOT NULL
,	ProductSk int NOT NULL
,	Quantity int NOT NULL 
) WITH	(DATA_COMPRESSION =PAGE);

CREATE TABLE
	dbo.FactCCIDemo
(
	SalesDateSk int NOT NULL
,	CustomerSk int NOT NULL
,	ProductSk int NOT NULL
,	Quantity int NOT NULL 
);

-- Create the CCI
-- 2016+ this can be part of the table DDL
CREATE CLUSTERED COLUMNSTORE INDEX CCI__dbo__FactCCIDemo
ON dbo.FactCCIDemo;

IF (@DemoParallelInsertPerformance = 'N')
BEGIN
INSERT INTO
	dbo.FactRowDemo
(
    SalesDateSk
,   CustomerSk
,   ProductSk
,   Quantity
)
SELECT
	D.SalesDateSk
,	C.CustomerSk
,	P.ProductSk
,	Q.Quantity
--INTO
--	dbo.FactRowDemo
FROM
(
	SELECT TOP (2000000) CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS int) AS Quantity
	FROM sys.all_columns AS AC
	CROSS APPLY sys.all_columns AS AC2
) Q
CROSS APPLY
(
	SELECT CAST(CONVERT(char(8), DATEADD(DAY, Q.Quantity % 364, DATEFROMPARTS(2018, 1,1)), 112) AS int)
)D(SalesDateSk)
CROSS APPLY
(
	SELECT Q.Quantity % 19
)P(ProductSk)
CROSS APPLY
(
	SELECT Q.Quantity % 57
)C(CustomerSk);
END
ELSE
BEGIN
	SELECT
		D.SalesDateSk
	,	C.CustomerSk
	,	P.ProductSk
	,	Q.Quantity
	INTO
		dbo.FactRowDemo
	FROM
	(
		SELECT TOP (2000000) CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS int) AS Quantity
		FROM sys.all_columns AS AC
		CROSS APPLY sys.all_columns AS AC2
	) Q
	CROSS APPLY
	(
		SELECT CAST(CONVERT(char(8), DATEADD(DAY, Q.Quantity % 364, DATEFROMPARTS(2018, 1,1)), 112) AS int)
	)D(SalesDateSk)
	CROSS APPLY
	(
		SELECT Q.Quantity % 19
	)P(ProductSk)
	CROSS APPLY
	(
		SELECT Q.Quantity % 57
	)C(CustomerSk);
END
-- stuff it into rowcompressed
INSERT INTO dbo.FactDemoPageCompressed
SELECT * FROM dbo.FactRowDemo AS FRD;

-- stuff it into page
INSERT INTO dbo.FactDemoRowCompressed
SELECT * FROM dbo.FactRowDemo AS FRD;

-- stuff it into CCI
INSERT INTO dbo.FactCCIDemo
SELECT * FROM dbo.FactRowDemo AS FRD;