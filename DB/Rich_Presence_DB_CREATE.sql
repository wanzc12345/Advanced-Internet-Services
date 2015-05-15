USE AIS;

CREATE TABLE Rich_Presence_DB (
  userID varchar(50) NOT NULL,
  timestamp datetime  NOT NULL,
  latitude float,
  longitude float,

  xAcc float,
  yAcc float,
  zAcc float,

  volume float,
  brightness float,
  batteryLevel float,

  OSType varchar(50),
  OSVersion varchar(50),
  serialNumber varchar(20),

  PRIMARY KEY(userID, timestamp),
  FOREIGN KEY (userID) references User_Info_DB(userID) on delete cascade
);