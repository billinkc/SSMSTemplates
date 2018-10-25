-------------------------------------------------------------------------------
-- The purpose of this script is to query all the databases to determine our
-- effective permissions. The use of sp_MSforeachdb is not the most reliable
-- but should be available everywhere
-- http://sqlblog.com/blogs/aaron_bertrand/archive/2010/12/29/a-more-reliable-and-more-flexible-sp-msforeachdb.aspx
--
-------------------------------------------------------------------------------

DECLARE @query nvarchar(4000) = N'
USE [?]

INSERT INTO
    ##PermissionResults
SELECT
    USER_NAME() AS WhoAmI
,   CAST(SERVERPROPERTY(''machinename'') AS sysname) + COALESCE(''\'' + CAST(SERVERPROPERTY(''Instancename'') AS nvarchar(80)), '''') AS ServerInstanceName
,   DB_NAME(DB_ID()) AS databaseName
,   fn.entity_name
,   fn.subentity_name
,   fn.permission_name
FROM
    sys.fn_my_permissions(NULL, ''DATABASE'') AS fn;';

CREATE TABLE
    ##PermissionResults
(
    WhoAmI sysname
,   ServerInstanceName sysname
,   databaseName sysname
,   entity_name sysname
,   subentity_name sysname
,   permission_name sysname
);

EXECUTE sys.sp_MSforeachdb @query;

SELECT
    PR.WhoAmI
,   PR.ServerInstanceName
,   PR.databaseName
,   PR.entity_name
,   PR.subentity_name
,   PR.permission_name
FROM
    ##PermissionResults AS PR;

DROP TABLE ##PermissionResults;
