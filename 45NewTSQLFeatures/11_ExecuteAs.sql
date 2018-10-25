-- EXECUTE AS
-- http://msdn.microsoft.com/en-us/library/ms188354.aspx
-- caller:  default mode
-- self:  person creating or altering the module
-- owner:  owner of the current module.
-- user_name:  specific user
-- login_name:  specific login

-- A contractor was set up that could create/modify procs but
-- couldn't assign permissions.  This silly proc
-- was created to serve as a crutch to programmatically grant
-- permissions to all procs to contractor + the website account
CREATE PROCEDURE [dbo].[PermissionReset]
WITH EXECUTE AS owner
AS
BEGIN
    SET NOCOUNT ON
    DECLARE Csr CURSOR FOR
    SELECT T.name
    FROM sys.objects T
    WHERE T.type = 'P'

    DECLARE
        @name varchar(500)
    ,   @tsql varchar(max)

    SET NOCOUNT ON
    OPEN Csr
    FETCH NEXT FROM Csr INTO
        @name
    WHILE (@@fetch_status <> -1)
    BEGIN
        IF (@@fetch_status <> -2)
        BEGIN
            SELECT @tsql = 'GRANT EXECUTE ON dbo.' + @name + ' TO [webUser]'
            EXEC(@tsql)
            SELECT @tsql = 'GRANT EXECUTE ON dbo.' + @name + ' TO [myDomain\dirtyContractor]'
            EXEC(@tsql)
        END
        FETCH NEXT FROM Csr INTO
        @name
    END
    CLOSE Csr
    DEALLOCATE Csr
END