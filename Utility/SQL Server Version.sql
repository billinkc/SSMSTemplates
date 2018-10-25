SELECT 
    SERVERPROPERTY('productversion') AS ProductVersion
,   SERVERPROPERTY ('productlevel') AS ProductLevel
,   SERVERPROPERTY('productupdatelevel') AS ProductUpdateLevel
,   SERVERPROPERTY ('edition') AS Edition;
