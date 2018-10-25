-- Kick everyone out.
-- Ensure you do not intellisense on lest it try and steal the connection
ALTER DATABASE <DatabaseName, nvarchar(4000), AdventureWorks2012>
SET SINGLE_USER
WITH ROLLBACK IMMEDIATE;

ALTER DATABASE <DatabaseName, nvarchar(4000), AdventureWorks2012>
SET MULTI_USER;
