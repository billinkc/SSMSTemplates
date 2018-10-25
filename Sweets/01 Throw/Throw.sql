
-- Example of rethrowing the error message up the call chain
BEGIN TRY
    SELECT 1/0 AS huuuuuur;
END TRY
BEGIN CATCH
    PRINT 'What''s the point of catching if we just rethrow the message?';
    -- This is the only place where one can just use THROW;
    --Msg 10704, Level 15, State 1, Line 1
    --To rethrow an error, a THROW statement must be used inside a CATCH block. 
    --Insert the THROW statement inside a CATCH block, or add error parameters 
    --to the THROW statement. 
    THROW;
END CATCH


DECLARE @Message NVARCHAR(2048);
SELECT @Message = 'lp0 on fire';
THROW 50001, @Message, 1;


