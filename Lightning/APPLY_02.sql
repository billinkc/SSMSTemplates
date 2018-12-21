USE WideWorldImporters

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
------
-- Show me the sales statistics behind each customers past 5 orders
-----
;WITH SEGMENTATION AS
(
	SELECT
		ROW_NUMBER() OVER (PARTITION BY SI.InvoiceID ORDER BY SI.InvoiceDate DESC) AS rn
	,	SI.CustomerId
	,	SIL.ExtendedPrice
	FROM
		Sales.Invoices AS SI
		INNER JOIN
			Sales.InvoiceLines AS SIL
			ON SI.InvoiceID = SIL.InvoiceID
)
SELECT
	C.CustomerId
,	COUNT_BIG(I.CustomerId) AS TotalInvoiceCount
,	SUM(S.ExtendedPrice) AS TotalSalesAmount
,	AVG(S.ExtendedPrice) AS AverageSalesAmount
,	MIN(S.ExtendedPrice) AS MinSalesAmount
,	MAX(S.ExtendedPrice) AS MaxSalesAmount
FROM
	Sales.Customers AS C
	INNER JOIN
		Sales.Invoices AS I
		ON I.CustomerId = C.CustomerId
	LEFT OUTER JOIN
		SEGMENTATION AS S
		ON S.CustomerID = C.CustomerID
		AND S.rn < 6
GROUP BY
	C.CustomerId
ORDER BY
	C.CustomerId
,	2;



SELECT
	C.CustomerId
,	COUNT_BIG(I.CustomerId) AS TotalInvoiceCount
,	SUM(S.ExtendedPrice) AS TotalSalesAmount
,	AVG(S.ExtendedPrice) AS AverageSalesAmount
,	MIN(S.ExtendedPrice) AS MinSalesAmount
,	MAX(S.ExtendedPrice) AS MaxSalesAmount
FROM
	Sales.Customers AS C
	INNER JOIN
		Sales.Invoices AS I
		ON I.CustomerId = C.CustomerId
	OUTER APPLY
	(
		SELECT TOP 5
		--	ROW_NUMBER() OVER (PARTITION BY SI.InvoiceID ORDER BY SI.InvoiceDate DESC) AS rn
		--, SI.CustomerId
		 	SIL.ExtendedPrice
		FROM
			Sales.Invoices AS SI
			INNER JOIN
				Sales.InvoiceLines AS SIL
				ON SI.InvoiceID = SIL.InvoiceID
		WHERE
			I.CustomerID = SI.CustomerID
		ORDER BY
			SI.InvoiceDate DESC
	) S
GROUP BY
	C.CustomerId
ORDER BY
	C.CustomerId
,	2;

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
