-- Retrieve query plans from the cache
SELECT
    DECP.*
,	DEQP.query_plan
FROM
    sys.dm_exec_cached_plans AS DECP
	-- And if we change this to OUTER, then what?
    CROSS APPLY sys.dm_exec_query_plan(DECP.plan_handle) AS DEQP;

-- XML shredding
DECLARE @xml xml = N'<row>
  <CustomerID>1</CustomerID>
  <CustomerName>Tailspin Toys (Head Office)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Shop 38</DeliveryAddressLine1>
  <DeliveryPostalCode>90410</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>2</CustomerID>
  <CustomerName>Tailspin Toys (Sylvanite, MT)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Shop 245</DeliveryAddressLine1>
  <DeliveryPostalCode>90216</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>3</CustomerID>
  <CustomerName>Tailspin Toys (Peeples Valley, AZ)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Unit 217</DeliveryAddressLine1>
  <DeliveryPostalCode>90205</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>4</CustomerID>
  <CustomerName>Tailspin Toys (Medicine Lodge, KS)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Suite 164</DeliveryAddressLine1>
  <DeliveryPostalCode>90152</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>5</CustomerID>
  <CustomerName>Tailspin Toys (Gasport, NY)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Unit 176</DeliveryAddressLine1>
  <DeliveryPostalCode>90261</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>6</CustomerID>
  <CustomerName>Tailspin Toys (Jessie, ND)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Shop 196</DeliveryAddressLine1>
  <DeliveryPostalCode>90298</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
<row>
  <CustomerID>7</CustomerID>
  <CustomerName>Tailspin Toys (Frankewing, TN)</CustomerName>
  <AccountOpenedDate>2013-01-01</AccountOpenedDate>
  <DeliveryAddressLine1>Shop 27</DeliveryAddressLine1>
  <DeliveryPostalCode>90761</DeliveryPostalCode>
  <LastEditedBy>1</LastEditedBy>
</row>
';

SELECT
	V.extractId
,	VP.payload.value(N'CustomerID[1]', 'int') AS CustomerId
,	VP.payload.value(N'CustomerName[1]', 'varchar(70)') AS CustomerName
,	VP.payload.value(N'AccountOpenedDate[1]', 'date') AS AccountOpenedDate
FROM
(
	VALUES(@xml, 32456) 
)	V(payload, extractId)
	CROSS APPLY
		V.payload.nodes('//row') AS vp(payload)



/*
SELECT TOP 7
    CustomerID
,   CustomerName
,   AccountOpenedDate
,   DeliveryAddressLine1
,   DeliveryPostalCode
,   LastEditedBy
FROM
    Sales.Customers
	
FOR XML PATH('row');
*/