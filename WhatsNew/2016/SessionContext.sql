SET NOCOUNT ON;
DECLARE @message varchar(300) = (SELECT CONCAT(SUSER_NAME(), ' is the greatest'))
EXEC sp_set_session_context 'Who is the greatest', @message, 1;
SELECT SESSION_CONTEXT(N'Who is the greatest');

EXEC sp_set_session_context 'Who is the greatest', 'Mike Fal is the greatest';
