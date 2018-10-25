/*****************************************************************************/
 
--  INSTRUCTIONS FOR USE
--  <ctrl> + <shift> + M to open parameters window to specify parameters.
--  See article at <insert URL> for location of parameter values in SSDT
 
USE <database_name, varchar(75), SSISDB>;
 
DECLARE @ExecutionID  BIGINT 

DECLARE
    @reference_id bigint = (
SELECT
    ER.reference_id
FROM
    catalog.environment_references AS ER
    INNER JOIN
        catalog.projects AS P
        ON P.project_id = ER.project_id
    INNER JOIN
        catalog.folders AS PF
        ON PF.folder_id = P.folder_id
WHERE
    P.name = 'AWShoppingCart'
    AND PF.name = 'Summit2015'
    AND ER.environment_folder_name = 'Configuration'
    AND ER.environment_name = 'SettingsUAT'
    AND ER.reference_type = 'A'
    );

/*****************************************************************************
--  First create an execution instance.  Data taps are valid for the specified
--  execution instance only
*****************************************************************************/
EXEC catalog.create_execution 
        N'<folder_name, nvarchar(128), Summit2015>',  --Folder name in SSISDB 
        N'<project_name, nvarchar(128), AWShoppingCart>', --Project name in SSISDB
        N'<package_name, nvarchar(260), AW_LoadShoppingCartItem.dtsx>', --Package name in SSISDB
        @reference_id, --optional parameter to hold reference ID for later use
        <use32bit_runtime, bit, 0>, --optional  parameter set to 1 if 32-bit runtime required
        @ExecutionID OUTPUT;
 
DECLARE @DataTapID BIGINT;
 
/******************************************************************************
--  Next create the actual data tap.  The parameters specified below deterimine
--  at which point in a specific package the data tap will be added.  
******************************************************************************/
EXEC catalog.add_data_tap
        @ExecutionID, --output from catalog.create_execution
        N'<task_package_path, nvarchar(max), \Package\FELC Process source files\DFT Load source data>', --PackagePath property value from data flow task in SSDT
        N'<data_flow_path_id_string, nvarchar(4000), Paths[DER Provide Defaults.Output]>', --IdentificationString property value from data flow task in SSDT
        N'<data_filename, nvarchar(4000), SummitFile.csv>', --Desired Output file name
        <max_rows, int, NULL>, --optional paramter to specify number of rows to log. NULL for all rows
        @DataTapID OUTPUT; --output ID
 
 
/******************************************************************************
--  This final block of code executes the package.  The data tap file output 
--  will be found in the %SSISRoot%\DataTaps directory upon completion
******************************************************************************/
EXEC catalog.start_execution 
        @ExecutionID;  --output from catalog.create_execution

PRINT 'Windows explorer to C:\Program Files\Microsoft SQL Server\110\DTS\DataDumps';
 