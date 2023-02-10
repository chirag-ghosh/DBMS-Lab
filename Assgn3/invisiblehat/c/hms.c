#include <stdio.h>
#include <libpq-fe.h> // library for database connections

// all the required queries
char queries[12][900] = {
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
};

// custom print function
void printResult(PGresult* result) {

    int rows = PQntuples(result);
    int cols = PQnfields(result);

    printf("\n");
    for(int i = 0; i < cols; i++) {
        printf("%s\t", PQfname(result, i));
    }
    printf("\n--------------------------------------------\n"); // header and data divider

    for(int i = 0; i < rows; i++) {
        for(int j = 0; j < cols; j++) {
            printf("%s\t", PQgetvalue(result, i, j));
        }
        printf("\n");
    }
    printf("\n");
}

int main() {
    
    // connection parameters for a local psql db
    PGconn *conn = PQconnectdb("user=invisiblehat dbname=20CS10020 port=5432");

    // status check
    if(PQstatus(conn) == CONNECTION_OK || PQstatus(conn) == CONNECTION_MADE) {

        printf("Database Connected\n\n");

        int choice = 0;
        PGresult *result;

        // enter menu
        printf("Welcome to the Hospital Management System!\n\nPlease select a query. Select 14 and you exit.\n");

        while(1) {
            printf("1: Names of all physicians who are trained in procedure name “bypass surgery”\n");
            printf("2: Names of all physicians affiliated with the department name “cardiology” and trained in “bypass surgery”\n");
            printf("3: Names of all the nurses who have ever been on call for room 123\n");
            printf("4: Names and addresses of all patients who were prescribed the medication named “remdesivir”\n");
            printf("5: Name and insurance id of all patients who stayed in the “icu” room type for more than 15 days\n");
            printf("6: Names of all nurses who assisted in the procedure name “bypass surgery”\n");
            printf("7: Name and position of all nurses who assisted in the procedure name “bypass surgery” along with the names of and the accompanying physicians\n");
            printf("8: Obtain the names of all physicians who have performed a medical procedure they have never been trained to perform\n");
            printf("9: Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)\n");
            printf("10: Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on\n");
            printf("11: Names of all patients (also include, for each patient, the name of the patient's physician), such that all the following are true:\n\t• The patient has been prescribed some medication by his/her physician\n\t• The patient has undergone a procedure with a cost larger that 5000\n\t• The patient has had at least two appointment where the physician was affiliated with the cardiology department\n\t• The patient's physician is not the head of any department\n");
            printf("12: Name and brand of the medication which has been prescribed to the highest number of patients\n");
            printf("13: Names of all physicians who are trained in procedure\n");
            printf("14: Exit\n");

            printf("\nYour choice -> ");
            scanf("%d", &choice);

            if(choice == 14) break;

            else if(choice == 13) {
                // special query
                result = PQexec(conn, "SELECT Name AS Procedure FROM Procedure");
                printf("Following are the procedures available in the database. Please select one\n");
                if (PQresultStatus(result) != PGRES_TUPLES_OK) {
                    printf("No data retrieved\n");        
                    PQclear(result);
                    PQfinish(conn);
                    return 1;
                }
                printResult(result);
                PQclear(result);

                printf("\nYour choice -> ");
                char temp[20], modifiedQuery[200];
                scanf("%s", &temp);
                sprintf(modifiedQuery, "SELECT Physician.Name AS Physician FROM Physician, Trained_In, PROCEDURE WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = '%s';", temp);
                
                result = PQexec(conn, modifiedQuery);
                if (PQresultStatus(result) != PGRES_TUPLES_OK) {
                    printf("No data retrieved\n");        
                    PQclear(result);
                    PQfinish(conn);
                    return 1;
                }
                printResult(result);
                PQclear(result);
            }
            else {
                // typical queries runner
                result = PQexec(conn, queries[choice-1]);
                if (PQresultStatus(result) != PGRES_TUPLES_OK) {
                    printf("No data retrieved\n");        
                    PQclear(result);
                    PQfinish(conn);
                    return 1;
                }
                printResult(result);
                PQclear(result);
            }
        }
    }
    else {
        printf("Database connection failed: %s\n", PQerrorMessage(conn));
    }

    PQfinish(conn);
    
    return 0;
}