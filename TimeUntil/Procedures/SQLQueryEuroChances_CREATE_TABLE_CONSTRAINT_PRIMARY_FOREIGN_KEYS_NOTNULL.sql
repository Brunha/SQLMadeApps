CREATE TABLE Users
(
UserId INT IDENTITY(1,1) NOT NULL,
UserDevice varchar(50),
UserName varchar(10),
UserEmail varchar(50),
CHECK (UserEmail LIKE '%_@_%mail.__%'),
UserPassword char(60),
CONSTRAINT PK_UserId PRIMARY KEY (UserID)
)

CREATE TABLE Probabilities
(
Number INT NOT NULL,
Probability INT NOT NULL,
CONSTRAINT PK_Number PRIMARY KEY (Number)
)

CREATE TABLE Draws
(
DrawId int NOT NULL,
DrawDate Datetime NOT NULL,
Prize decimal(9,2),
ValueOne int NOT NULL,
ValueTwo int NOT NULL,
ValueThree int NOT NULL,
ValueFour int NOT NULL,
ValueFive int NOT NULL,
StarValueOne int NOT NULL,
StarValueTwo int NOT NULL,
DrawAvgProb int,
CONSTRAINT Pk_DrawId PRIMARY KEY (DrawId)
)

CREATE TABLE Results
(
DrawId int NOT NULL,
UserId int FOREIGN KEY REFERENCES Users(UserId) NOT NULL,
DrawDate DATETIME NOT NULL,
ValueOne int NOT NULL,
ValueTwo int NOT NULL,
ValueThree int NOT NULL,
ValueFour int NOT NULL,
ValueFive int NOT NULL,
StarValueOne int NOT NULL,
StarValueTwo int NOT NULL,
Prize decimal (9,2),
CONSTRAINT Pk_DrawDate PRIMARY KEY (DrawId)
)

CREATE TABLE UserUnlocks
(
DrawID int NOT NULL,
DrawDate Datetime,
)

CREATE TABLE UserLogOn
(
UserLogOnID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
UserID INT NOT NULL,
UserLogOnHash VARBINARY(32),
UserLogOnStatus BIT,
CONSTRAINT PK_UserLogOn FOREIGN KEY (UserID) REFERENCES Users
)

CREATE TABLE LimitUser
(
LimitUserID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
UserID int NOT NULL,
Payment BIT NOT NULL,
ProgramCount INT
)

SELECT NEWID() AS UNIQUEVALUE

SELECT CHECKSUM('Hello') AS CHECKSUMVALUE

SELECT ABS(NEWID()) AS ABSVALUE

SELECT ABS(CHECKSUM(NEWID())) AS RandomNumber

CREATE PROCEDURE GenerateSecureValue
AS
BEGIN
    DECLARE @RandomNumber INT = ABS(CHECKSUM(NEWID()));
    DECLARE @Salt VARBINARY(64);	-- CHAR(36) = CONVERT(CHAR(36), NEWID());
    DECLARE @ConcatenatedValue VARCHAR(150) = CONCAT(CAST(@RandomNumber AS VARCHAR(11)), CAST(@Salt AS VARCHAR(128)));		--	CONCAT(@RandomNumber, @Salt);
    DECLARE @HashedValue VARBINARY(32) = HASHBYTES('SHA2_256', @ConcatenatedValue);

	SELECT @Salt = UserPasswordSalt FROM Users

    SELECT @RandomNumber AS RandomNumber, @Salt AS Salt, @HashedValue AS HashedValue;
END;
