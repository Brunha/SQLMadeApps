--	USER LOGIN

ALTER PROC UserLogIn
(
@useremail nvarchar(50),
@password NVARCHAR(10)
)
AS
BEGIN

	DECLARE @passwordhash VARBINARY(32);
	DECLARE @salt VARBINARY(16);
	DECLARE @userpasswordsalt VARBINARY(16);
	DECLARE @userid int;
	DECLARE @inputpasswordhash VARBINARY(32);

		--	checking if the user exists
	SELECT @passwordhash = UserPasswordHash,
			@salt = UserPasswordSalt FROM Users
			WHERE @useremail = UserEmail

	IF (@passwordhash IS NULL)
		BEGIN
			PRINT 'User NOT FOUND.';
			RETURN -1; -- USER NOT FOUND
		END
	ELSE
		BEGIN

			-- Generate the password salt for hash
			EXEC GenerateUnStoredSalt @salt, @password, @userpasswordsalt OUTPUT;

			-- Hash the password with the salt	
			--	SET @inputpasswordhash = HASHBYTES('SHA2_256', @userpasswordsalt);
			EXEC GeneratePasswordHash @userpasswordsalt, @inputpasswordhash OUTPUT;

			IF @inputpasswordhash = @passwordhash
			BEGIN
				PRINT 'LogIn Successful.';
				RETURN 1;	--	lOGIN SUCCESSFUL
			END
			ELSE
			BEGIN 
				PRINT 'LogIn Failed.';
				RETURN 0;	--	LOGING FAILED
			END
		END
END;

SELECT * FROM Users

EXEC UserLogIn @useremail = 'something@somemail.com', @password = 'Ola'

--	USER EDIT

ALTER PROC UserEdit
(
@useremail NVARCHAR(50),
@password NVARCHAR(10),
@editemail NVARCHAR(50) = NULL,
@editpassword NVARCHAR(10) = NULL,
@editusername NVARCHAR(10) = NULL
)
AS
BEGIN
	DECLARE @check int;
	DECLARE @userid int;

	EXEC @check = UserLogIn @useremail, @password;

	IF (@check = 1)
	BEGIN
		SELECT @userid = userid FROM Users
		WHERE UserEmail = @useremail

		IF (@editemail IS NOT NULL)
		BEGIN
			IF(@useremail <> @editemail)
				BEGIN
					UPDATE Users SET UserEmail = @editemail WHERE UserID = @userid
					RETURN 1;
					PRINT 'User Email Updated Sucessfully.';
				END
			ELSE IF (@useremail = @editemail)
				BEGIN
					RETURN 0;
					PRINT 'Emails are the same.';
				END
			ELSE
				BEGIN
					RETURN -1;
					PRINT 'Email editation process failed.';
				END
		END
		ELSE IF(@editusername IS NOT NULL)
			BEGIN
				UPDATE Users SET UserName = @editusername WHERE UserID = @userid
				RETURN 1;
				PRINT 'User Updated Sucessfully.';
			END
		ELSE IF (@editpassword IS NOT NULL)
			BEGIN 

				DECLARE @usersalt VARBINARY(16);
				DECLARE @userpasswordsalt VARBINARY(16);
				DECLARE @userpasswordhash VARBINARY(32);
				DECLARE @editpasswordhash VARBINARY(32);

				SELECT @usersalt = UserPasswordSalt, @userpasswordhash = UserPasswordHash FROM Users
				WHERE @userid = @userid

				-- Hash the password with the salt
				--	SET @editpasswordhash = HASHBYTES('SHA2_256', @editpassword + CONVERT(NVARCHAR, @usersalt, 1));
				EXEC GenerateUnstoredSalt @usersalt, @editpassword, @userpasswordsalt OUTPUT;

				EXEC GeneratePasswordHash @userpasswordsalt, @editpasswordhash OUTPUT;

				IF (@editpasswordhash <> @userpasswordhash)
					BEGIN
						-- Generate a new salt (safety)
						EXEC GenerateUserSalt @usersalt OUTPUT;

						-- Hash the password with the salt
						--	SET @userpasswordhash = HASHBYTES('SHA2_256', @editpassword + CONVERT(NVARCHAR, @usersalt, 1));
						EXEC GenerateUnStoredSalt @usersalt, @editpassword, @editpasswordhash OUTPUT;

						-- Insert the user changes into the database
						UPDATE Users SET UserPasswordHash = @editpasswordhash, UserPasswordSalt = @usersalt
						WHERE UserID = @userid

						RETURN 1;
						PRINT 'User Updated Sucessfully.';

					END 
				ELSE IF (@editpasswordhash = @userpasswordhash)
					BEGIN 
						RETURN 0;
						PRINT 'Passwords are similiar.';
					END
				ELSE
					BEGIN
						RETURN -1;
						PRINT 'User Update Process Failed.';
					END

				RETURN 1;
				PRINT 'User Updated Sucessfully.';
			END
		ELSE
			BEGIN
				RETURN -1;
				PRINT 'User Update Process Failed.';
			END
	END
END;


SELECT NEWID() AS UNIQUEVALUE

SELECT CHECKSUM('Hello') AS CHECKSUMVALUE

SELECT ABS(NEWID()) AS ABSVALUE

SELECT ABS(CHECKSUM(NEWID())) AS RandomNumber

CREATE PROCEDURE GenerateSecureValue
AS
BEGIN
    DECLARE @RandomNumber INT = ABS(CHECKSUM(NEWID()));
    DECLARE @Salt VARBINARY(16);	-- CHAR(36) = CONVERT(CHAR(36), NEWID());
    DECLARE @ConcatenatedValue VARCHAR(150) = CONCAT(CAST(@RandomNumber AS VARCHAR(11)),
	CAST(@Salt AS VARCHAR(128)));		--	CONCAT(@RandomNumber, @Salt);
    DECLARE @HashedValue VARBINARY(32) = HASHBYTES('SHA2_256', @ConcatenatedValue);

	SELECT @Salt = UserPasswordSalt FROM Users

    SELECT @RandomNumber AS RandomNumber, @Salt AS Salt, @HashedValue AS HashedValue;
END;