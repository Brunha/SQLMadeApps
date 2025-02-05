
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Username NVARCHAR(100) NOT NULL,
    PasswordHash VARBINARY(64) NOT NULL,
    Salt VARBINARY(16) NOT NULL
);

-- Function to generate a random salt
--CREATE FUNCTION GenerateUserSalt()
--RETURNS VARBINARY(16)
--AS
--BEGIN
--    DECLARE @salt VARBINARY(16);
--    SET @salt = CAST(CRYPT_GEN_RANDOM(16) AS VARBINARY(16));
--    RETURN @salt;
--END;

--	CREATE PROC of user password salt, returning the value

CREATE PROC GenerateUserSalt
@salt VARBINARY(16) OUTPUT

AS BEGIN
	SET @salt = CAST(CRYPT_GEN_RANDOM(16) AS varbinary(16));

	END;
GO

CREATE PROC GenerateUnStoredSalt
@salt VARBINARY(16),
@password NVARCHAR(10),
@userpasswordsalt VARBINARY(36) OUTPUT
AS
BEGIN
    -- Combine password and salt using CONVERT for explicit conversion
	SET @userpasswordsalt = CONVERT(VARBINARY(20), @password) + @salt;
END;

CREATE PROC GeneratePasswordHash
@passwordsalt VARBINARY(16),
@passwordhash VARBINARY(36) OUTPUT
AS
BEGIN
	-- Hash the password with the salt
		SET @passwordHash = HASHBYTES('SHA2_256', @passwordsalt);
END;

 --	Procedure to create a user with hashed password
ALTER PROCEDURE CheckAndCreateUser (
    @Username NVARCHAR(10),
	@Useremail NVARCHAR(50),
    @Password NVARCHAR(10)
)
AS
BEGIN
	--	checking if the user exists
	IF NOT EXISTS (SELECT 1 FROM Users WHERE UserEmail = @userEmail)
	BEGIN
		-- CREATE THE USER
		DECLARE @salt VARBINARY(16);
		DECLARE @passwordHash VARBINARY(32);
		DECLARE @passwordSalt VARBINARY(16);

		-- Generate a salt
    EXEC GenerateUserSalt @salt OUTPUT;

		-- Generate the password salt
	EXEC GenerateUnStoredSalt @salt, @password, @passwordSalt OUTPUT;

    -- Hash the password with the salt
    --SET @passwordHash = HASHBYTES('SHA2_256', @passwordSalt);
	EXEC GeneratePasswordHash @passwordsalt, @passwordhash OUTPUT;

	-- Insert the user into the database
    INSERT INTO Users (UserName, UserEmail, UserPasswordHash, UserPasswordSalt)
    VALUES (@Username, LOWER(@useremail), @passwordHash, @salt);

		PRINT 'User Created.';

	END
	ELSE
	BEGIN
		PRINT 'User Already exists.';
	END
    
END;

DELETE FROM USERS
WHERE UserName like 'Bru'

EXEC CheckAndCreateUser @username = 'Bru', @useremail = 'something@somemail.com', @password = 'Ola'

SELECT * FROM Users

DELETE FROM Users
WHERE UserID = 2