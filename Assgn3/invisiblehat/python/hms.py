#!/usr/bin/python

import psycopg2

def printResult(rows, cols):
    print()
    for col in cols:
        print(col, end='\t')
    print("\n-------------------------------------------------------------------")
    for row in rows:
        for col in range(len(cols)):
            print(row[col], end='\t')
        print()
    print()

def connect():
    queries = [
        "SELECT Physician.Name AS Physician FROM Physician, Trained_In, PROCEDURE WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery';",
        "SELECT Physician.Name AS Physician FROM Physician, Trained_In, PROCEDURE, Affiliated_With, Department WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery' AND Physician.EmployeeID = Affiliated_With.Physician AND Affiliated_With.Department = Department.DepartmentID AND Department.Name = 'Cardiology';",
        "SELECT Name AS Nurse FROM Nurse, On_Call, Room WHERE EmployeeID = On_Call.Nurse AND On_Call.BlockFloor = Room.BlockFloor AND On_Call.BlockCode = Room.BlockCode AND Room.Number = 123;",
        "SELECT Patient.Name AS Patient, Address FROM Patient, Prescribes, Medication WHERE SSN = Prescribes.Patient AND Prescribes.Medication = Medication.Code AND Medication.Name = 'remdesivir';",
        "SELECT Patient.Name AS Patient, InsuranceID FROM Patient, ( SELECT Patient, SUM (EndTime :: date - StartTime :: date) FROM Stay, Room WHERE Stay.Room = Room.Number AND Room.Type = 'icu' GROUP BY Patient ) AS StayCount WHERE Patient.SSN = StayCount.Patient;",
        "SELECT Nurse.Name AS Nurse FROM Nurse, Undergoes, PROCEDURE WHERE Nurse.EmployeeID = Undergoes.AssistingNurse AND Undergoes.Procedure = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery';",
        "SELECT Nurse.Name AS Nurse, Nurse.Position AS Position, Physician.Name AS AccompanyingPhysician FROM Nurse, Undergoes, PROCEDURE, Physician WHERE Nurse.EmployeeID = Undergoes.AssistingNurse AND Undergoes.Procedure = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery' AND Undergoes.Physician = Physician.EmployeeID;",
        "SELECT Physician.Name AS Physician FROM Physician, ( SELECT Physician, PROCEDURE FROM Undergoes EXCEPT SELECT Physician, Treatment FROM Trained_In ) AS Untrained WHERE Untrained.Physician = Physician.EmployeeID;",
        "SELECT Physician.Name AS Physician FROM Trained_In, Undergoes, Physician WHERE Undergoes.Procedure = Trained_In.Treatment AND Undergoes.Physician = Trained_In.Physician AND Physician.EmployeeID = Undergoes.Physician AND ( Undergoes.Date :: date - Trained_In.CertificationExpires :: date ) > 0;",
        "SELECT Physician.Name AS Physician, PROCEDURE.Name AS Procedure, Undergoes.Date :: date as Date, Patient.Name AS Patient FROM Trained_In, Undergoes, Physician, PROCEDURE, Patient WHERE Undergoes.Procedure = Trained_In.Treatment AND Undergoes.Physician = Trained_In.Physician AND Physician.EmployeeID = Undergoes.Physician AND ( Undergoes.Date :: date - Trained_In.CertificationExpires :: date ) > 0 AND Undergoes.Procedure = PROCEDURE.Code AND Undergoes.Patient = Patient.SSN;",
        "SELECT Name, Brand FROM ( SELECT Medication, COUNT(DISTINCT Patient) AS PCount FROM Prescribes GROUP BY Medication ) AS PrescriptionCount, Medication WHERE PCount IN ( SELECT MAX (PCount) AS PCount FROM ( SELECT Medication, COUNT(DISTINCT Patient) AS PCount FROM Prescribes GROUP BY Medication ) AS PrescriptionMax ) AND PrescriptionCount.Medication = Medication.Code;",
        "SELECT Patient.name AS Patient, Physician.name AS Physician FROM Patient, Physician WHERE Physician.EmployeeID = Patient.PCP AND EXISTS ( SELECT Patient FROM Prescribes WHERE Prescribes.Patient = Patient.SSN AND Prescribes.Physician = Patient.PCP ) AND EXISTS ( SELECT Patient FROM Undergoes, Procedure WHERE Undergoes.Patient = Patient.SSN AND Undergoes.Procedure = Procedure.Code AND Procedure.Cost > 5000 ) AND NOT EXISTS ( SELECT DepartmentID FROM Department WHERE Department.Head = Patient.PCP )AND EXISTS ( SELECT Appointment.Patient, Count(AppointmentID) AS AppointmentCount FROM Appointment, Affiliated_With, Department WHERE Appointment.Patient = Patient.SSN AND Appointment.Physician = Affiliated_With.Physician AND Affiliated_With.Department = Department.DepartmentID AND Department.Name = 'Cardiology' GROUP BY Appointment.Patient HAVING Count(AppointmentID) >= 2 );"
    ];
    conn = None

    try:
        conn = psycopg2.connect(
            host="localhost",
            port="5432",
            user="invisiblehat",
            database="20CS10020"
            )
        print("Database Connected")

        cursor = conn.cursor()
        
        print("Welcome to the Hospital Management System!\n\nPlease select a query. Select 14 and you exit.\n")

        while True:
            print("1: Names of all physicians who are trained in procedure name “bypass surgery”\n")
            print("2: Names of all physicians affiliated with the department name “cardiology” and trained in “bypass surgery”\n")
            print("3: Names of all the nurses who have ever been on call for room 123\n")
            print("4: Names and addresses of all patients who were prescribed the medication named “remdesivir”\n")
            print("5: Name and insurance id of all patients who stayed in the “icu” room type for more than 15 days\n")
            print("6: Names of all nurses who assisted in the procedure name “bypass surgery”\n")
            print("7: Name and position of all nurses who assisted in the procedure name “bypass surgery” along with the names of and the accompanying physicians\n")
            print("8: Obtain the names of all physicians who have performed a medical procedure they have never been trained to perform\n")
            print("9: Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)\n")
            print("10: Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on\n")
            print("11: Names of all patients (also include, for each patient, the name of the patient's physician), such that all the following are true:\n\t• The patient has been prescribed some medication by his/her physician\n\t• The patient has undergone a procedure with a cost larger that 5000\n\t• The patient has had at least two appointment where the physician was affiliated with the cardiology department\n\t• The patient's physician is not the head of any department\n")
            print("12: Name and brand of the medication which has been prescribed to the highest number of patients\n")
            print("13: Names of all physicians who are trained in procedure\n")
            print("14: Exit\n")

            print("\nYour choice -> ", end='', flush=True)
            choice = int(input())

            if choice == 14:
                break
            elif choice == 13:
                cursor.execute("SELECT Name AS Procedure FROM Procedure")
                rows = cursor.fetchall()
                cols = [desc[0] for desc in cursor.description]
                print("Following are the procedures available in the database. Please select one")
                printResult(rows, cols)

                print("\nYour choice -> ", end='', flush=True)
                procedureName = input()
                cursor.execute("SELECT Physician.Name AS Physician FROM Physician, Trained_In, PROCEDURE WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = '" + procedureName + "';")
                rows = cursor.fetchall()
                cols = [desc[0] for desc in cursor.description]
                printResult(rows, cols)
            else:
                cursor.execute(queries[choice-1])
                rows = cursor.fetchall()
                cols = [desc[0] for desc in cursor.description]
                printResult(rows, cols)

        cursor.close()

    except (Exception, psycopg2.DatabaseError) as err:
        print("Database connection failed: " + err)

    finally:
        if conn != None:
            conn.close()

if __name__ == '__main__':
    connect()