IF EXISTS
(
    SELECT
        SO.*
    FROM
        dbo.sysobjects SO
    WHERE
        SO.id = OBJECT_ID('<schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>')
        AND OBJECTPROPERTY(SO.id, 'IsProcedure') = 1;
)
BEGIN
    PRINT 'Dropping stored procedure <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>';
    DROP PROCEDURE <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>;
END
PRINT 'Creating stored procedure <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>';
GO
-----------------------------------------------------------------------------
-- Function: <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>
-- Author: Full name
-- Date: yyyy-mm-dd
--
-- This procedure ...
--
-- Recordsets:
-- None
--
-- Side-effects:
-- None
--
-- See also:
--
-- Modified:
--
-- yyyy-mm-dd username
--
-----------------------------------------------------------------------------
CREATE PROCEDURE <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>
(
)
AS
BEGIN
    SET NOCOUNT ON;

END
GO
PRINT 'Granting rights for <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure>';
GRANT EXECUTE ON <schemaName, sysname, dbo>.<procName, sysname, AwesomeProcedure> TO [];
GO