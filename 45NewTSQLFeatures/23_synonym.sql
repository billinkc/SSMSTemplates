-- SYNONYM
-- http://msdn.microsoft.com/en-us/library/ms177544.aspx

USE master;
GO

CREATE SYNONYM MasterWorks
FOR FOURTY_FIVE.stage.WORKS;
GO

SELECT * FROM master.dbo.MasterWorks

GO
DROP SYNONYM dbo.MasterWorks