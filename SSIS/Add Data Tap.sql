*****************************************************************************/
 
--  INSTRUCTIONS FOR USE
--  <ctrl> + <shift> + M to open parameters window to specify parameters.
--  See article at <insert URL> for location of parameter values in SSDT
 
USE <database_name, varchar(75), SSISDB>;
 
DECLARE @ExecutionID  BIGINT 
 
/*****************************************************************************
--  First create an execution instance.  Data taps are valid for the specified
--  execution instance only
*****************************************************************************/
EXEC catalog.create_execution 
        N'<folder_name, nvarchar(128), Folder1>',  --Folder name in SSISDB 
        N'<project_name, nvarchar(128), Project1>', --Project name in SSISDB
        N'<package_name, nvarchar(260), PackageName1>', --Package name in SSISDB
        <reference_id, int, NULL>, --optional parameter to hold reference ID for later use
        <use32bit_runtime, bit, 0>, --optional  parameter set to 1 if 32-bit runtime required
        @ExecutionID OUTPUT;
 
DECLARE @DataTapID BIGINT;
 
/******************************************************************************
--  Next create the actual data tap.  The parameters specified below deterimine
--  at which point in a specific package the data tap will be added.  
******************************************************************************/
EXEC catalog.add_data_tap
        @ExecutionID, --output from catalog.create_execution
        N'<task_package_path, nvarchar(max), Path1\Path2\>', --PackagePath property value from data flow task in SSDT
        N'<data_flow_path_id_string, nvarchar(4000), Paths[Data Flow Transformation1]>', --IdentificationString property value from data flow task in SSDT
        N'<data_filename, nvarchar(4000), File.csv>', --Desired Output file name
        <max_rows, int, NULL>, --optional paramter to specify number of rows to log. NULL for all rows
        @DataTapID OUTPUT; --output ID
 
 
/******************************************************************************
--  This final block of code executes the package.  The data tap file output 
--  will be found in the %SSISRoot%\DataTaps directory upon completion
******************************************************************************/
EXEC catalog.start_execution 
        @ExecutionID;  --output from catalog.create_execution
 