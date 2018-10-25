USE [SSISDB]
GO

DECLARE
    @folder_name nvarchar(128)
,   @project_name nvarchar(128)
,   @environment_name nvarchar(128);

DECLARE Csr CURSOR
READ_ONLY FOR 
SELECT
    CF.name AS folder_name
FROM
    catalog.folders AS CF
--WHERE
--    CF.name IN ('');
;

OPEN Csr;
FETCH NEXT FROM Csr INTO
    @folder_name;
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

        -------------------------------------------------------------
        -- Drop any projects
        -------------------------------------------------------------
        DECLARE FCsr CURSOR
        READ_ONLY FOR 
        SELECT
            CP.name AS project_name 
        FROM
            catalog.projects AS CP
            INNER JOIN
                catalog.folders AS CF
                ON CF.folder_id = CP.folder_id
        WHERE
            CF.name = @folder_name;

        OPEN FCsr;
        FETCH NEXT FROM FCsr INTO
            @project_name;
        WHILE(@@FETCH_STATUS = 0)
        BEGIN
            EXECUTE catalog.delete_project
                @folder_name
            ,   @project_name;

            FETCH NEXT FROM FCsr INTO
                @project_name;
        END
        CLOSE FCsr;
        DEALLOCATE FCsr;

        -------------------------------------------------------------
        -- Drop any environments
        -------------------------------------------------------------
        DECLARE ECsr CURSOR
        READ_ONLY FOR 
        SELECT
            E.name AS project_name 
        FROM
            catalog.environments AS E 
            INNER JOIN
                catalog.folders AS CF
                ON CF.folder_id = E.folder_id
        WHERE
            CF.name = @folder_name;

        OPEN ECsr;
        FETCH NEXT FROM ECsr INTO
            @environment_name;
        WHILE(@@FETCH_STATUS = 0)
        BEGIN
            EXECUTE catalog.delete_environment             
                @folder_name
            ,   @environment_name;

            FETCH NEXT FROM ECsr INTO
                @environment_name;
        END
        CLOSE ECsr;
        DEALLOCATE ECsr;

        -------------------------------------------------------------
        -- Finally, remove the folder
        -------------------------------------------------------------
        EXECUTE [catalog].[delete_folder]
            @folder_name;

    END
	FETCH NEXT FROM Csr INTO
        @folder_name;

END

CLOSE Csr;
DEALLOCATE Csr;
