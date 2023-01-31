SELECT
    Physician.Name
FROM
    Physician,
    Trained_In,
    PROCEDURE
WHERE
    Physician.EmployeeID = Trained_In.Physician
    AND Trained_In.Treatment = PROCEDURE.Code
    AND PROCEDURE.Name = 'bypass surgery';


SELECT
    Physician.Name
FROM
    Physician,
    Trained_In,
    PROCEDURE,
    Affiliated_With,
    Department
WHERE
    Physician.EmployeeID = Trained_In.Physician
    AND Trained_In.Treatment = PROCEDURE.Code
    AND PROCEDURE.Name = 'bypass surgery'
    AND Physician.EmployeeID = Affiliated_With.Physician
    AND Affiliated_With.Department = Department.DepartmentID
    AND Department.Name = 'Cardiology';


SELECT
    Name
FROM
    Nurse,
    On_Call,
    Room
WHERE
    EmployeeID = On_Call.Nurse
    AND On_Call.BlockFloor = Room.BlockFloor
    AND On_Call.BlockCode = Room.BlockCode
    AND Room.Number = 123;


SELECT
    Patient.Name,
    Address
FROM
    Patient,
    Prescribes,
    Medication
WHERE
    SSN = Prescribes.Patient
    AND Prescribes.Medication = Medication.Code
    AND Medication.Name = 'remdesivir';