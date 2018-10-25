SELECT
    F.folder_id
,   F.name
,   P.project_id
,   P.folder_id
,   P.name
,   P.description
    -- wat?! Documentation states 1 = 2005 beta
    -- http://msdn.microsoft.com/en-us/library/ff878098.aspx
,   P.project_format_version
,   P.deployed_by_name
,   P.last_deployed_time
,   P.created_time
,   P.object_version_lsn
,   P.validation_status
,   P.last_validation_time
,   PKG.package_id
,   PKG.name
,   PKG.package_guid
,   PKG.description
,   PKG.package_format_version
,   PKG.version_major
,   PKG.version_minor
,   PKG.version_build
,   PKG.version_comments
,   PKG.version_guid
,   PKG.project_id
,   PKG.entry_point
,   PKG.validation_status
,   PKG.last_validation_time
FROM
    ssisdb.catalog.folders AS F
    INNER JOIN 
        SSISDB.catalog.projects AS P
        ON P.folder_id = F.folder_id
    INNER JOIN
        SSISDB.catalog.packages AS PKG
        ON PKG.project_id = P.project_id
ORDER BY
    F.name
,   P.name
,   PKG.name;
