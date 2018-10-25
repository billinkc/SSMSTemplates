SELECT
    RM.role_principal_id
,   RM.member_principal_id
,   U.name
,   U.principal_id
,   U.type
,   U.type_desc
,   U.default_schema_name
,   U.create_date
,   U.modify_date
,   U.owning_principal_id
,   U.sid
,   U.is_fixed_role
,   U.authentication_type
,   U.authentication_type_desc
,   U.default_language_name
,   U.default_language_lcid
,   R.name
,   R.principal_id
,   R.type
,   R.type_desc
,   R.default_schema_name
,   R.create_date
,   R.modify_date
,   R.owning_principal_id
,   R.sid
,   R.is_fixed_role
,   R.authentication_type
,   R.authentication_type_desc
,   R.default_language_name
,   R.default_language_lcid
FROM
    sys.database_role_members AS RM
    INNER JOIN 
        sys.database_principals AS U
        ON RM.member_principal_id = U.principal_id
    INNER JOIN 
        sys.database_principals AS R
        ON RM.role_principal_id = R.principal_id
