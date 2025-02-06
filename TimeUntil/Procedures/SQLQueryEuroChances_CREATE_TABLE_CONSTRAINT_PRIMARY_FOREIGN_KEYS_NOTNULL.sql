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


