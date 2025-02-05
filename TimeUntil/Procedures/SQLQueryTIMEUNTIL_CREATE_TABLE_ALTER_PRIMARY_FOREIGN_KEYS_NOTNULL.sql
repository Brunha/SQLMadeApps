CREATE TABLE Users 
(
UserId int IDENTITY(1,1) PRIMARY KEY NOT NULL,
UserCode varchar(250)
)

ALTER TABLE Users
ADD UserPasswordSalt VARBINARY(16) NOT NULL
ADD UserPasswordHash VARBINARY(64) NOT NULL

CREATE TABLE SavedLastTimeType
(
LastTimeTypeID INT PRIMARY KEY IDENTITY(1,1),
LastTimeTypeName varchar(10) NOT NULL
)

ALTER TABLE Users
ADD CONSTRAINT PK_UserEmail_Check CHECK (UserEmail LIKE '%_@_%mail.__%')
--DROP COLUMN UserDevice
--ADD UserName varchar(10),
ADD UserEmail varchar(50),
CHECK (UserEmail LIKE '%_@_%mail.__%'),
--ADD UserPassword char(60)

CREATE TABLE TimeLeft
(
TimeID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
TimerName varchar(50) NOT NULL,
TimerDescription varchar(100),
EndDate datetime NOT NULL,
LastTimeTypeID int,
UserId int,
CONSTRAINT FK_TimeLeft_Users FOREIGN KEY (UserID) REFERENCES Users,
CONSTRAINT FK_TimeLeft_SavedLastTimeType FOREIGN KEY (LastTimeTypeID) REFERENCES SavedLastTimeType
)

CREATE TABLE DateSpan
(
DateSpanID int IDENTITY(1,1) PRIMARY KEY NOT NULL,
DateSpanTimeType varchar(10) NOT NULL,
StartDate datetime NOT NULL,
EndDate datetime NOT NULL
)

CREATE TABLE WeekDays
(
WeekdaysID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
Monday BIT,
Tuesday BIT,
Wednesday BIT,
Thrusday BIT,
Friday BIT,
Saturday BIT,
Sunday BIT
)

CREATE TABLE Routine
(
RoutineID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
RoutineName varchar(10) NOT NULL,
RoutineDescription varchar(50),
DateSpanID int NOT NULL,
RoutineStop BIT NOT NULL,
WeekDaysID int,
SavedLastTimeTypeID int,
CONSTRAINT FK_DateSpan_Routine FOREIGN KEY (DateSpanID) REFERENCES DateSpan,
CONSTRAINT FK_Weekdays_Routine FOREIGN KEY (WeekDaysID) REFERENCES WeekDays,
CONSTRAINT FK_SavedLastTimeType_Routine FOREIGN KEY (SavedLastTimeTypeID) REFERENCES SavedLastTimeType
)
