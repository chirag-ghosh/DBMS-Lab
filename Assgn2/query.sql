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


SELECT
    Patient.Name,
    InsuranceID
FROM
    Patient,
    (
        SELECT
            Patient,
            SUM (EndTime :: date - StartTime :: date)
        FROM
            Stay,
            Room
        WHERE
            Stay.Room = Room.Number
            AND Room.Type = 'icu'
        GROUP BY
            Patient
    ) AS StayCount
WHERE
    Patient.SSN = StayCount.Patient;


SELECT
    Nurse.Name
FROM
    Nurse,
    Undergoes,
    PROCEDURE
WHERE
    Nurse.EmployeeID = Undergoes.AssistingNurse
    AND Undergoes.Procedure = PROCEDURE.Code
    AND PROCEDURE.Name = 'bypass surgery';


SELECT
    Nurse.Name AS Name,
    Nurse.Position AS Position,
    Physician.Name AS AccompanyingPhysician
FROM
    Nurse,
    Undergoes,
    PROCEDURE,
    Physician
WHERE
    Nurse.EmployeeID = Undergoes.AssistingNurse
    AND Undergoes.Procedure = PROCEDURE.Code
    AND PROCEDURE.Name = 'bypass surgery'
    AND Undergoes.Physician = Physician.EmployeeID;


SELECT
    Physician.Name
FROM
    Physician,
    (
        SELECT
            Physician,
            PROCEDURE
        FROM
            Undergoes
        EXCEPT
        SELECT
            Physician,
            Treatment
        FROM
            Trained_In
    ) AS Untrained
WHERE
    Untrained.Physician = Physician.EmployeeID;


SELECT
    Physician.Name
FROM
    Trained_In,
    Undergoes,
    Physician
WHERE
    Undergoes.Procedure = Trained_In.Treatment
    AND Undergoes.Physician = Trained_In.Physician
    AND Physician.EmployeeID = Undergoes.Physician
    AND (
        Undergoes.Date :: date - Trained_In.CertificationExpires :: date
    ) > 0;


SELECT
    Physician.Name,
    PROCEDURE.Name,
    Undergoes.Date :: date,
    Patient.Name
FROM
    Trained_In,
    Undergoes,
    Physician,
    PROCEDURE,
    Patient
WHERE
    Undergoes.Procedure = Trained_In.Treatment
    AND Undergoes.Physician = Trained_In.Physician
    AND Physician.EmployeeID = Undergoes.Physician
    AND (
        Undergoes.Date :: date - Trained_In.CertificationExpires :: date
    ) > 0
    AND Undergoes.Procedure = PROCEDURE.Code
    AND Undergoes.Patient = Patient.SSN;


SELECT
    Name,
    Brand
FROM
    (
        SELECT
            Medication,
            COUNT(DISTINCT Patient) AS PCount
        FROM
            Prescribes
        GROUP BY
            Medication
    ) AS PrescriptionCount,
    Medication
WHERE
    PCount IN (
        SELECT
            MAX (PCount) AS PCount
        FROM
            (
                SELECT
                    Medication,
                    COUNT(DISTINCT Patient) AS PCount
                FROM
                    Prescribes
                GROUP BY
                    Medication
            ) AS PrescriptionMax
    )
    AND PrescriptionCount.Medication = Medication.Code;


SELECT
    Patient.name AS Patient,
    Physician.name AS Physician
FROM
    Patient,
    Physician
WHERE
    Physician.EmployeeID = Patient.PCP
    AND EXISTS (
        SELECT
            Patient
        FROM
            Prescribes
        WHERE
            Prescribes.Patient = Patient.SSN
            AND Prescribes.Physician = Patient.PCP
    )
    AND EXISTS (
        SELECT
            Patient
        FROM
            Undergoes, Procedure
        WHERE
            Undergoes.Patient = Patient.SSN
            AND Undergoes.Procedure = Procedure.Code
            AND Procedure.Cost > 5000
    ) AND NOT EXISTS (
        SELECT
            DepartmentID
        FROM
            Department
        WHERE
            Department.Head = Patient.PCP
    )AND EXISTS (
        SELECT
            Appointment.Patient, Count(AppointmentID) AS AppointmentCount
        FROM
            Appointment, Affiliated_With, Department
        WHERE
            Appointment.Patient = Patient.SSN
            AND Appointment.Physician = Affiliated_With.Physician
            AND Affiliated_With.Department = Department.DepartmentID
            AND Department.Name = 'Cardiology'
        GROUP BY
            Appointment.Patient
        HAVING
            Count(AppointmentID) >= 2
    );