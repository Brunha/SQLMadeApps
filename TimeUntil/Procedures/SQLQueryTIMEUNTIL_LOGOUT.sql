--	USER LOGOUT

CREATE PROC UserLogOut
@randomkey VARBINARY(32)
AS
BEGIN
	DECLARE @checkrandomkey VARBINARY(32);
	DECLARE @checkLogInDate DATETIME;
	DECLARE @checkLogOutDate DATETIME;
	DECLARE @userID INT;

	SELECT @checkrandomkey = RandomKey, @userID = UserID FROM UserLogOn
	WHERE @checkrandomkey = RandomKey

	IF (@checkrandomkey IS NOT NULL)
	BEGIN	
		UPDATE UserLogs
		SET LogOutDate = GETDATE() FROM UserLogs
		INNER JOIN UserLogOn ON UserLogOn.UserID = UserLogs.UserID
		WHERE UserLogs.UserLogsID = ( SELECT TOP 1 UserLogs.UserLogsID FROM UserLogs
									WHERE Userlogs.UserID = @userID
									ORDER BY UserLogs.UserLogsID DESC)

		--UPDATE UserLogs
		--SET LogOutDate = GETDATE() FROM UserLogs
		--INNER JOIN UserLogOn ON UserLogOn.UserID = UserLogs.UserID
		--WHERE UserLogs.UserID = (SELECT MAX(UserLogs.UserID) FROM UserLogs
		--						 WHERE UserLog.UserID = UserLogOn.UserID)

		DELETE FROM UserLogOn
		WHERE @randomkey = RandomKey

		RETURN 1;
		PRINT 'LogOut Successfully.';
	END 
	ELSE IF (@checkrandomkey IS NULL)
	BEGIN
		DELETE FROM UserLogOn
		WHERE @userID = @userID

		RETURN 0;
		PRINT 'LogOut Unsuccessfull.';
	END
	ELSE
	BEGIN 
		RETURN -1;
		PRINT 'LogOut Process failed.';
	END
	
END