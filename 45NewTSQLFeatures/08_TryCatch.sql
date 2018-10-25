-- Try/Catch
-- A Try Catch block in TSQL is a mechanism for designating
-- code that may raise an error or exception and safely handle
-- the situation
--
-- Developers in other languages have long had the ability to
-- create blocks for performing operations that may result in
-- exceptions.  In TSQL your only option had been to check
-- @@error after every operation.  That can be especially troubling
-- as _every_ statement affects the value of @@error, even the act of
-- inspecting the value of @@error.  A Try/Catch block in TSQL is
-- the begining of writing safer code.
--
-- Syntax
-- Try catch blocks use a similar BEGIN/END mechanism as the blocks used
-- for IF THEN, WHILE and other constructs except it's named with TRY or CATCH

SET NOCOUNT ON;
GO
-- query completed with errors
SELECT 1/0 AS div_zero
GO

-- Developer tries harder, except doesn't know how to read BOL
DECLARE @ErrorCode int
SELECT 1/0 AS div_zero
SELECT @@error AS [@@error]
SET @errorCode = @@error
SELECT @errorCode AS errorCode
GO

-- error handled and query executes successfully
BEGIN TRY
     SELECT 1/0 AS handled_div_zero
END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER()AS error_number --returns the number of the error.
,   ERROR_SEVERITY() AS error_severity --returns the severity.
,   ERROR_STATE()AS error_state  --returns the error state number.
,   ERROR_PROCEDURE() AS error_procedure --returns the name of the stored procedure or trigger where the error occurred.
,   ERROR_LINE() AS error_line --returns the line number inside the routine that caused the error.
,   ERROR_MESSAGE() AS error_message --returns the complete text of the error message. The text includes the values supplied for any substitutable parameters, such as lengths, object names, or times.
END CATCH

-- String or binary data would be truncated
-- As much as you might like to see *which* row
-- has the overflow value, the error_line will only
-- show the begining of the statement (INSERT INTO)
;
DECLARE @t TABLE
(
   zee_key char(1) NOT NULL PRIMARY KEY
)

BEGIN TRY
INSERT INTO
    @t
SELECT
    'A' AS zee_key
UNION ALL SELECT 'B'
UNION ALL SELECT 'C'
UNION ALL SELECT 'BB'

END TRY
BEGIN CATCH
SELECT
    ERROR_NUMBER()AS error_number --returns the number of the error.
,   ERROR_SEVERITY() AS error_severity --returns the severity.
,   ERROR_STATE()AS error_state  --returns the error state number.
,   ERROR_PROCEDURE() AS error_procedure --returns the name of the stored procedure or trigger where the error occurred.
,   ERROR_LINE() AS error_line --returns the line number inside the routine that caused the error.
,   ERROR_MESSAGE() AS error_message --returns the complete text of the error message. The text includes the values supplied for any substitutable parameters, such as lengths, object names, or times.

END CATCH
