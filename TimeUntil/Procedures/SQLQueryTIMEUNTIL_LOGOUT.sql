--	USER LOGOUT

CREATE PROC UserLogOut
@randomkey VARBINARY(32)
AS
BEGIN
	DECLARE @checkrandomkey VARBINARY(32);
	DECLARE @checkLogInDate DATETIME;
	DECLARE @checkLogOutDate DATETIME;

	SELECT @checkrandomkey = RandomKey FROM UserLogOn
	WHERE @checkrandomkey = RandomKey

	IF (@checkrandomkey IS NOT NULL)
	BEGIN
		
		UPDATE UserLogs
		SET LogOutDate = GETDATE() FROM UserLogs
		INNER JOIN UserLogOn ON UserLogOn.UserID = UserLogs.UserID
		WHERE UserLogs.UserID = (SELECT MAX(UserLogs.UserID) FROM UserLogs
								 WHERE UserLog.UserID = UserLogOn.UserID)

		DELETE FROM UserLogOn
		WHERE @randomkey = RandomKey



		RETURN 1;
		PRINT 'LogOut Successfully.';
	END
	
END