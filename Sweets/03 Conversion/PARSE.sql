-- PARSE
--http://msdn.microsoft.com/en-us/library/hh213316(v=sql.110).aspx

--Null values passed as arguments to PARSE are treated in two ways:
--	If a null constant is passed, an error is raised. A null value cannot be 
--  parsed into a different data type in a culturally aware manner.

--	If a parameter with a null value is passed at run time, then a null is 
--  returned, to avoid canceling the whole batch.

--Use PARSE only for converting from string to date/time and number types. 
--For general type conversions, continue to use CAST or CONVERT. Keep in mind 
--that there is a certain performance overhead in parsing the string value.

--PARSE  relies on the presence of .the .NET Framework Common Language Runtime (CLR).

--This function will not be remoted since it depends on the presence of the CLR. 
--Remoting a function that requires the CLR would cause an error on the remote server.
SET NOCOUNT ON

DECLARE
    @whammies bit = 0

DECLARE
    @DATES TABLE
(
    event_date char(10) NOT NULL PRIMARY KEY
,   meta varchar(30) NOT NULL
)

DECLARE
    @CULTURES TABLE
(
    culture sysname PRIMARY KEY
)

INSERT INTO
    @DATES
-- Table value constructor, new with 2008
-- http://technet.microsoft.com/en-us/library/dd776382.aspx
VALUES
    -- The correct century is 1900 for Dairy Milk
    ('01-02-05', 'Dairy Milk')
,   ('04.07.1932', 'Penguin')
,   ('02.30.2013', 'Whammy whammy whammy')

INSERT INTO
    @CULTURES 
SELECT 'en-US'
UNION ALL SELECT 'en-GB'
UNION ALL SELECT 'ja-JP'

ConsideredHarmful:

IF (@whammies = 0)
BEGIN
    SELECT
        event_date
    ,   culture
    ,   CONVERT(varchar(15), what_is_it, 109) AS reveal
    ,   meta
    FROM
        (
            SELECT
                D.event_date
            ,   D.meta
            ,   C.culture
            ,   PARSE(D.event_date AS date using C.culture) AS what_is_it
            FROM
                @DATES D
                CROSS APPLY
                    @CULTURES C
            WHERE
                D.meta != 'Whammy whammy whammy'
        ) CULTURE_HAMMER 
    ORDER BY
        1,2,3
END
ELSE
BEGIN
    BEGIN TRY

        SELECT
            event_date
        ,   culture
        ,   CONVERT(varchar(15), what_is_it, 109) AS reveal
        ,   meta
        FROM
            (
                SELECT
                    D.event_date
                ,   D.meta
                ,   C.culture
                ,   PARSE(D.event_date AS date using C.culture) AS what_is_it
                FROM
                    @DATES D
                    CROSS APPLY
                        @CULTURES C
                WHERE
                    D.meta = 'Whammy whammy whammy'
            ) CULTURE_HAMMER 
        ORDER BY
            1,2,3
    END TRY
    BEGIN CATCH
        SELECT
            --returns the number of the error.
            ERROR_NUMBER()AS error_number 
            --returns the severity.
        ,   ERROR_SEVERITY() AS error_severity 
            --returns the error state number.
        ,   ERROR_STATE()AS error_state  
            --returns the name of the stored procedure or trigger where the error occurred.
        ,   ERROR_PROCEDURE() AS error_procedure 
            --returns the line number inside the routine that caused the error.
        ,   ERROR_LINE() AS error_line 
            --returns the complete text of the error message. The text includes the values 
            -- supplied for any substitutable parameters, such as lengths, object names, or times.
        ,   ERROR_MESSAGE() AS error_message 
    END CATCH
    GOTO Done
END

SET
    @whammies = 1

GOTO ConsideredHarmful

Done:

-- Turkish Delight, 1914
-- Boost, 1985
-- Dairy Milk, 1905
-- Star Bar, 1976
-- Time Out, 1992
-- Wispa, 1981
-- Snack, 1974
-- Maynards Wine Gums, 1909