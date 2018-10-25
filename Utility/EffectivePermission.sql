SELECT
    USER_NAME() AS WhoAmI
,   CAST(SERVERPROPERTY('machinename') AS sysname) + COALESCE('\' + CAST(SERVERPROPERTY('Instancename') AS nvarchar(80)), '') AS ServerInstanceName
,   DB_NAME(DB_ID()) AS databaseName
,   fn.entity_name
,   fn.subentity_name
,   fn.permission_name
FROM
    sys.fn_my_permissions(NULL, 'DATABASE') AS fn;

SELECT
    fn.class_desc
,   fn.permission_name
,   fn.type
,   fn.covering_permission_name
,   fn.parent_class_desc
,   fn.parent_covering_permission_name
FROM
    sys.fn_builtin_permissions('SERVER') AS fn
ORDER BY
    permission_name;
