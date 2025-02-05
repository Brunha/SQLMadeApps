--	ALTER TABLE Users
	--	ALTER COLUMN Username VARCHAR(10) NOT NULL
	--	ALTER COLUMN UserEmail nvarchar(50) NOT NULL
	--	ADD CONSTRAINT UNQ_UserEmail UNIQUE (UserEmail)
	--	ADD CONSTRAINT CHK_UserEmail CHECK (UserEmail LIKE '%_@_%mail.__%'),
	--	ALTER COLUMN UserPasswordHash VARBINARY(32) NOT NULL,
    --	ALTER COLUMN UserPasswordSalt VARBINARY(16) NOT NULL

CREATE PROCEDURE StoreUserPassword
    @Username NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    DECLARE @Salt VARBINARY(16) = CAST(NEWID() AS VARBINARY(16));
    DECLARE @PasswordSalt VARBINARY(MAX) = CONCAT(CAST(@Password AS VARBINARY(MAX)), @Salt);
    DECLARE @HashedPassword VARBINARY(32) = HASHBYTES('SHA2_256', @PasswordSalt);

    INSERT INTO Users (Username, HashedPassword, Salt)
    VALUES (@Username, @HashedPassword, @Salt);
END;

CREATE PROCEDURE ValidateUserPassword
    @Username NVARCHAR(50),
    @Password NVARCHAR(50)
AS
BEGIN
    DECLARE @StoredSalt VARBINARY(16);
    DECLARE @StoredHashedPassword VARBINARY(32);

    -- Retrieve the stored salt and hashed password for the given username
    SELECT @StoredSalt = Salt, @StoredHashedPassword = HashedPassword
    FROM Users
    WHERE Username = @Username;

    -- If the user is not found
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Invalid Username';
        RETURN;
    END

    -- Convert the entered password to VARBINARY and concatenate with the stored salt
    DECLARE @PasswordSalt VARBINARY(MAX) = CONCAT(CAST(@Password AS VARBINARY(MAX)), @StoredSalt);

    -- Hash the combined password and salt using SHA2_256
    DECLARE @HashedPassword VARBINARY(32) = HASHBYTES('SHA2_256', @PasswordSalt);

    -- Compare the computed hash with the stored hash
    IF @HashedPassword = @StoredHashedPassword
    BEGIN
        PRINT 'Login Successful';
    END
    ELSE
    BEGIN
        PRINT 'Invalid Password';
    END
END;
