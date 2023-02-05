package com.blacktshirt;

import java.sql.*;
import java.util.Properties;
import java.util.Scanner;

/**
 * Hello world!
 */
public final class App {

    private App() {
    }

    public static void printResult(ResultSet rs, int columnCount, String[] columnNames) {
        System.out.println();
        for (String column : columnNames) {
            System.out.print(column + "\t");
        }
        System.out.println("\n---------------------------------------------------------");
        try {
            while(rs.next()) {
                for(int i = 1; i <= columnCount; i++) {
                    System.out.print(rs.getString(i) + "\t");
                }
                System.out.println();
            }
            System.out.println();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Says hello to the world.
     * @param args The arguments of the program.
     */
    public static void main(String[] args) {

        String[] queries = {
            "SELECT Physician.Name FROM Physician, Trained_In, PROCEDURE WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery';",
            "SELECT Physician.Name FROM Physician, Trained_In, PROCEDURE, Affiliated_With, Department WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery' AND Physician.EmployeeID = Affiliated_With.Physician AND Affiliated_With.Department = Department.DepartmentID AND Department.Name = 'Cardiology';",
            "SELECT Name FROM Nurse, On_Call, Room WHERE EmployeeID = On_Call.Nurse AND On_Call.BlockFloor = Room.BlockFloor AND On_Call.BlockCode = Room.BlockCode AND Room.Number = 123;",
            "SELECT Patient.Name, Address FROM Patient, Prescribes, Medication WHERE SSN = Prescribes.Patient AND Prescribes.Medication = Medication.Code AND Medication.Name = 'remdesivir';",
            "SELECT Patient.Name, InsuranceID FROM Patient, ( SELECT Patient, SUM (EndTime :: date - StartTime :: date) FROM Stay, Room WHERE Stay.Room = Room.Number AND Room.Type = 'icu' GROUP BY Patient ) AS StayCount WHERE Patient.SSN = StayCount.Patient;",
            "SELECT Nurse.Name FROM Nurse, Undergoes, PROCEDURE WHERE Nurse.EmployeeID = Undergoes.AssistingNurse AND Undergoes.Procedure = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery';",
            "SELECT Nurse.Name AS Name, Nurse.Position AS Position, Physician.Name AS AccompanyingPhysician FROM Nurse, Undergoes, PROCEDURE, Physician WHERE Nurse.EmployeeID = Undergoes.AssistingNurse AND Undergoes.Procedure = PROCEDURE.Code AND PROCEDURE.Name = 'bypass surgery' AND Undergoes.Physician = Physician.EmployeeID;",
            "SELECT Physician.Name FROM Physician, ( SELECT Physician, PROCEDURE FROM Undergoes EXCEPT SELECT Physician, Treatment FROM Trained_In ) AS Untrained WHERE Untrained.Physician = Physician.EmployeeID;",
            "SELECT Physician.Name FROM Trained_In, Undergoes, Physician WHERE Undergoes.Procedure = Trained_In.Treatment AND Undergoes.Physician = Trained_In.Physician AND Physician.EmployeeID = Undergoes.Physician AND ( Undergoes.Date :: date - Trained_In.CertificationExpires :: date ) > 0;",
            "SELECT Physician.Name, PROCEDURE.Name, Undergoes.Date :: date, Patient.Name FROM Trained_In, Undergoes, Physician, PROCEDURE, Patient WHERE Undergoes.Procedure = Trained_In.Treatment AND Undergoes.Physician = Trained_In.Physician AND Physician.EmployeeID = Undergoes.Physician AND ( Undergoes.Date :: date - Trained_In.CertificationExpires :: date ) > 0 AND Undergoes.Procedure = PROCEDURE.Code AND Undergoes.Patient = Patient.SSN;",
            "SELECT Name, Brand FROM ( SELECT Medication, COUNT(DISTINCT Patient) AS PCount FROM Prescribes GROUP BY Medication ) AS PrescriptionCount, Medication WHERE PCount IN ( SELECT MAX (PCount) AS PCount FROM ( SELECT Medication, COUNT(DISTINCT Patient) AS PCount FROM Prescribes GROUP BY Medication ) AS PrescriptionMax ) AND PrescriptionCount.Medication = Medication.Code;",
            "SELECT Patient.name AS Patient, Physician.name AS Physician FROM Patient, Physician WHERE Physician.EmployeeID = Patient.PCP AND EXISTS ( SELECT Patient FROM Prescribes WHERE Prescribes.Patient = Patient.SSN AND Prescribes.Physician = Patient.PCP ) AND EXISTS ( SELECT Patient FROM Undergoes, Procedure WHERE Undergoes.Patient = Patient.SSN AND Undergoes.Procedure = Procedure.Code AND Procedure.Cost > 5000 ) AND NOT EXISTS ( SELECT DepartmentID FROM Department WHERE Department.Head = Patient.PCP )AND EXISTS ( SELECT Appointment.Patient, Count(AppointmentID) AS AppointmentCount FROM Appointment, Affiliated_With, Department WHERE Appointment.Patient = Patient.SSN AND Appointment.Physician = Affiliated_With.Physician AND Affiliated_With.Department = Department.DepartmentID AND Department.Name = 'Cardiology' GROUP BY Appointment.Patient HAVING Count(AppointmentID) >= 2 );"
        };

        Scanner sc = new Scanner(System.in);

        // connection parameters for a local psql db
        Connection conn;
        String url = "jdbc:postgresql://localhost:5432/20CS10020";
        Properties props = new Properties();
        props.setProperty("user", "invisiblehat");

        Statement st;
        ResultSet rs;

        try {

            //connect to db
            conn = DriverManager.getConnection(url, props);
            System.out.println("Database connected");

            //enter menu
            System.out.println("\nWelcome!\n\nPlease select a query. Select 14 to exit!");
            while(true) {
                System.out.println("1-> Names of all physicians who are trained in procedure name “bypass surgery”");
                System.out.println("2-> Names of all physicians affiliated with the department name “cardiology” and trained in “bypass surgery”");
                System.out.println("3-> Names of all the nurses who have ever been on call for room 123");
                System.out.println("4-> Names and addresses of all patients who were prescribed the medication named “remdesivir”");
                System.out.println("5-> Name and insurance id of all patients who stayed in the “icu” room type for more than 15 days");
                System.out.println("6-> Names of all nurses who assisted in the procedure name “bypass surgery”");
                System.out.println("7-> Name and position of all nurses who assisted in the procedure name “bypass surgery” along with the names of and the accompanying physicians");
                System.out.println("8-> Obtain the names of all physicians who have performed a medical procedure they have never been trained to perform");
                System.out.println("9-> Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)");
                System.out.println("10-> Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on");
                System.out.println("11-> Names of all patients (also include, for each patient, the name of the patient's physician), such that all the following are true:\n\t• The patient has been prescribed some medication by his/her physician\n\t• The patient has undergone a procedure with a cost larger that 5000\n\t• The patient has had at least two appointment where the physician was affiliated with the cardiology department\n\t• The patient's physician is not the head of any department");
                System.out.println("12-> Name and brand of the medication which has been prescribed to the highest number of patients");
                System.out.println("13-> Names of all physicians who are trained in a procedure");
                System.out.println("14-> Exit");

                System.out.print("\nYour choice -> ");
                int choice = Integer.parseInt(sc.nextLine());

                if(choice == 14) break;
                else if(choice == 13) {
                    st = conn.createStatement();
                    rs = st.executeQuery("SELECT Name FROM Procedure");
                    System.out.println("Following are the procedures available in the database. Please select one");
                    printResult(rs, 1, new String[]{"Procedure"});
                    System.out.print("\nYour choice -> ");
                    String procedureChoice = sc.nextLine();
                    rs = st.executeQuery("SELECT Physician.Name FROM Physician, Trained_In, PROCEDURE WHERE Physician.EmployeeID = Trained_In.Physician AND Trained_In.Treatment = PROCEDURE.Code AND PROCEDURE.Name = '" + procedureChoice + "';");
                    printResult(rs, 1, new String[]{"Physician"});
                }
                else {
                    st = conn.createStatement();
                    rs = st.executeQuery(queries[choice-1]);
                    switch (choice) {
                        case 1:
                        case 2:
                        case 8:
                        case 9:
                            printResult(rs, 1, new String[]{"Physician"});
                            break;
                        case 3:
                        case 6:
                            printResult(rs, 1, new String[]{"Nurse"});
                            break;
                        case 4:
                            printResult(rs, 2, new String[]{"Patient", "Address"});
                            break;
                        case 5:
                            printResult(rs, 2, new String[]{"Patient", "Insurance ID"});
                            break;
                        case 7:
                            printResult(rs, 3, new String[]{"Nurse", "Position", "Accompanying Physician"});
                            break;
                        case 10:
                            printResult(rs, 4, new String[]{"Physician", "Procedure", "Date", "Patient"});
                            break;
                        case 11:
                            printResult(rs, 2, new String[]{"Name", "Brand"});
                            break;
                        case 12:
                            printResult(rs, 2, new String[]{"Patient", "Physician"});
                            break;
                        default:
                            break;
                    }
                    rs.close();
                    st.close();
                }
            }
            sc.close();
        } catch (SQLException e) {
            e.printStackTrace();
            sc.close();
            return;
        }
    }
}
