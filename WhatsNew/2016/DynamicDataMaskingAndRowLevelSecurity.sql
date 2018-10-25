USE DemoDb
REVERT;
SET NOCOUNT ON;
-- Clean up our mess before begining
DROP SECURITY POLICY IF EXISTS dbo.FilterCustomerByTerritory;
DROP TABLE IF EXISTS dbo.CUSTOMER;
DROP FUNCTION IF EXISTS dbo.TerritoryCheck;
DROP USER IF EXISTS WestUser;
DROP ROLE IF EXISTS WestTerritory;
DROP USER IF EXISTS EastUser;
DROP ROLE IF EXISTS EastTerritory;

-- A table of customers to demo RLS and data masking
CREATE TABLE dbo.CUSTOMER
(
    CustomerSk int IDENTITY(1, 1) NOT NULL
    -- Default mask
,   CustomerName varchar(100) MASKED WITH(FUNCTION ='default()') NOT NULL
    -- Mask with 0 leading characters, use X as mask, and show last 4 characters
,   BankAccountNumber nvarchar(20) MASKED WITH(FUNCTION='partial(0,"XXXX", 4)') NOT NULL
    -- Built in email obfuscator. See BOL note
    -- Masking method which exposes the first letter of an email address and the constant suffix ".com"
    -- , in the form of an email address
,   EmailAddress nvarchar(100) MASKED WITH(FUNCTION='email()') NOT NULL
    -- Generate a psuedo random value
,   TaxId bigint MASKED WITH(FUNCTION='random(1000, 5000)') NOT NULL
,   SalesTerritory varchar(50) NOT NULL
,   NetWorth numeric(18,2) MASKED WITH(FUNCTION ='default()') NOT NULL
);
GO
---------------------------------------------------------------
-- Return a 1 if we're dbo or where the Territory aligns with
-- our group membership
-- Values like East, West, HQ
---------------------------------------------------------------
CREATE FUNCTION dbo.TerritoryCheck(@SalesTerritory varchar(50))
RETURNS TABLE
WITH SCHEMABINDING
AS
RETURN (SELECT 1 AS AccessResult
        WHERE IS_ROLEMEMBER(N'db_owner') <> 0
        OR IS_ROLEMEMBER(@SalesTerritory + N'Territory') <> 0
);
GO
-- 
CREATE SECURITY POLICY dbo.FilterCustomerByTerritory
ADD FILTER PREDICATE dbo.TerritoryCheck(SalesTerritory)
    ON dbo.CUSTOMER,
ADD BLOCK PREDICATE dbo.TerritoryCheck(SalesTerritory)
    ON dbo.CUSTOMER AFTER UPDATE
WITH
(STATE = ON, SCHEMABINDING = ON);


CREATE ROLE WestTerritory;
CREATE ROLE EastTerritory;

GRANT SELECT, INSERT, UPDATE ON dbo.CUSTOMER TO WestTerritory;
GRANT SELECT, INSERT, UPDATE ON dbo.CUSTOMER TO EastTerritory;
GRANT UNMASK TO EastTerritory;

GRANT SHOWPLAN TO WestTerritory;
GRANT SHOWPLAN TO EastTerritory;


CREATE USER WestUser WITHOUT LOGIN;
ALTER ROLE WestTerritory ADD MEMBER WestUser;
CREATE USER EastUser WITHOUT LOGIN;
ALTER ROLE EastTerritory ADD MEMBER EastUser;

INSERT INTO
    dbo.CUSTOMER
(
    CustomerName
,   BankAccountNumber
,   EmailAddress
,   TaxId
,   SalesTerritory
,   NetWorth
)
SELECT
*
FROM
(
    VALUES
        ('Bob', '8575824136', 'bob@bobbit.com', 9876, 'West', 10000.76)
    ,   ('Terry', '1234567890', 'tmoney@fiction.net', 5555, 'West', 400.55)
    ,   ('George', '1234567890', 'smiley@tinker.tailor.uk', 5432, 'East', 72111239.32)
    ,   ('Anna', '9876561111', 'anna@rex.com', 1133, 'HQ', 6666.33)
    ,   ('Erin', '9876564321', 'erin@island.ie', 4478, 'HQ', 443322.78)
)D(CustomerName, BankAccountNumber, EmailAddress, TaxId, SalesTerritory,  NetWorth)
WHERE NOT EXISTS
(
    SELECT * FROM dbo.CUSTOMER AS C
    WHERE C.CustomerName = D.CustomerName
);

SELECT USER_NAME() AS WhoAmI,* FROM dbo.CUSTOMER AS C;
EXECUTE AS USER = 'WestUser';
SELECT USER_NAME() AS WhoAmI,* FROM dbo.CUSTOMER AS C;
REVERT;
EXECUTE AS USER = 'EastUser';
SELECT USER_NAME() AS WhoAmI,* FROM dbo.CUSTOMER AS C;
REVERT;

-- How secure is Data Masking?
-- Super secure ;)
EXECUTE AS USER = 'WestUser';

SELECT USER_NAME() AS WhoAmI,* FROM dbo.CUSTOMER AS C WHERE C.NetWorth > 10000;

-- anything exposed when we look at the virtual tables?
UPDATE 
    C
SET
    C.NetWorth = C.NetWorth * 1
OUTPUT
    Deleted.NetWorth AS NetWorthDeleted
,   Inserted.NetWorth AS NetWorthInserted
,   Inserted.CustomerSk
,   USER_NAME() AS WhoAmI
FROM
    dbo.CUSTOMER AS C;

-- Try to move territory to demonstate security block
--Msg 33504, Level 16, State 1, Line 111
--The attempted operation failed because the target object 'tempdb.dbo.CUSTOMER' has a block predicate that conflicts with this operation. If the operation is performed on a view, the block predicate might be enforced on the underlying table. Modify the operation to target only the rows that are allowed by the block predicate.
UPDATE 
    C
SET
    SalesTerritory = 'HQ'
FROM
    dbo.CUSTOMER AS C;

REVERT;
PRINT 'Bill just ran the whole script. Taunt him for his foolishness';