CREATE TABLE Physician (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR (50) NOT NULL,
    Position VARCHAR (100) NOT NULL,
    SSN INT NOT NULL
);


CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY NOT NULL,
    Name VARCHAR (50) NOT NULL,
    Head INT NOT NULL,
    FOREIGN KEY (Head) REFERENCES Physician (EmployeeID)
);


CREATE TABLE Affiliated_With (
    Physician INT NOT NULL,
    Department INT NOT NULL,
    PrimaryAffiliation BOOLEAN NOT NULL,
    PRIMARY KEY (Physician, Department),
    FOREIGN KEY (Physician) REFERENCES Physician (EmployeeID),
    FOREIGN KEY (Department) REFERENCES Department (DepartmentID)
);


CREATE TABLE PROCEDURE (
    Code INT PRIMARY KEY NOT NULL,
    Name VARCHAR (100) NOT NULL,
    Cost INT NOT NULL
);


CREATE TABLE Trained_In (
    Physician INT NOT NULL,
    Treatment INT NOT NULL,
    CertificationDate TIMESTAMP NOT NULL,
    CertificationExpires TIMESTAMP NOT NULL,
    PRIMARY KEY (Physician, Treatment),
    FOREIGN KEY (Physician) REFERENCES Physician (EmployeeID),
    FOREIGN KEY (Treatment) REFERENCES PROCEDURE (Code)
);


CREATE TABLE Patient (
    SSN INT PRIMARY KEY NOT NULL,
    Name VARCHAR (50) NOT NULL,
    Address VARCHAR (200) NOT NULL,
    Phone VARCHAR (20) NOT NULL,
    InsuranceID INT NOT NULL,
    PCP INT NOT NULL,
    FOREIGN KEY (PCP) REFERENCES Physician(EmployeeID)
);


CREATE TABLE Nurse (
    EmployeeID INT PRIMARY KEY NOT NULL,
    Name VARCHAR (50) NOT NULL,
    Position VARCHAR (100) NOT NULL,
    Registered BOOLEAN NOT NULL,
    SSN INT NOT NULL
);


CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY NOT NULL,
    Patient INT NOT NULL,
    PrepNurse INT,
    Physician INT NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    ExaminationRoom VARCHAR (100) NOT NULL,
    FOREIGN KEY (patient) REFERENCES patient (ssn),
    FOREIGN KEY (PrepNurse) REFERENCES Nurse (EmployeeID),
    FOREIGN KEY (Physician) REFERENCES Physician (EmployeeID)
);


CREATE TABLE Medication (
    Code INT PRIMARY KEY NOT NULL,
    Name VARCHAR (50) NOT NULL,
    Brand VARCHAR (50) NOT NULL,
    Description VARCHAR (100) NOT NULL
);


CREATE TABLE Prescribes (
    Physician INT NOT NULL,
    Patient INT NOT NULL,
    Medication INT NOT NULL,
    Date TIMESTAMP NOT NULL,
    Appointment INT,
    Dose VARCHAR (50) NOT NULL,
    PRIMARY KEY (Physician, Patient, Medication, Date),
    FOREIGN KEY (Physician) REFERENCES Physician (EmployeeID),
    FOREIGN KEY (Patient) REFERENCES Patient(SSN),
    FOREIGN KEY (Medication) REFERENCES Medication (Code),
    FOREIGN KEY (Appointment) REFERENCES Appointment (AppointmentID)
);


CREATE TABLE Block (
    Floor INT NOT NULL,
    Code INT NOT NULL,
    PRIMARY KEY (Floor, Code)
);


CREATE TABLE Room (
    Number INT PRIMARY KEY NOT NULL,
    TYPE VARCHAR (50) NOT NULL,
    BlockFloor INT NOT NULL,
    BlockCode INT NOT NULL,
    Unavailable BOOLEAN NOT NULL,
    FOREIGN KEY (BlockFloor, BlockCode) REFERENCES Block
);


CREATE TABLE On_Call (
    Nurse INT NOT NULL,
    BlockFloor INT NOT NULL,
    BLockCode INT NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    PRIMARY KEY (Nurse, BlockFloor, BLockCode, StartTime, EndTime),
    FOREIGN KEY (Nurse) REFERENCES Nurse(EmployeeID),
    FOREIGN KEY (BLockFloor, BLockCode) REFERENCES Block
);


CREATE TABLE Stay (
    StayID INT PRIMARY KEY NOT NULL,
    Patient INT NOT NULL,
    Room INT NOT NULL,
    StartTime TIMESTAMP NOT NULL,
    EndTime TIMESTAMP NOT NULL,
    FOREIGN KEY (Patient) REFERENCES Patient (SSN),
    FOREIGN KEY (Room) REFERENCES Room (Number)
);


CREATE TABLE Undergoes (
    Patient INT NOT NULL,
    PROCEDURE INT NOT NULL,
    Stay INT NOT NULL,
    Date TIMESTAMP NOT NULL,
    Physician INT NOT NULL,
    AssistingNurse INT,
    PRIMARY KEY (Patient, PROCEDURE, Stay, Date),
    FOREIGN KEY (Patient) REFERENCES Patient (SSN),
    FOREIGN KEY (PROCEDURE) REFERENCES PROCEDURE (Code),
    FOREIGN KEY (Stay) REFERENCES Stay (StayID),
    FOREIGN KEY (Physician) REFERENCES Physician(EmployeeID),
    FOREIGN KEY (AssistingNurse) REFERENCES Nurse(EmployeeID)
);