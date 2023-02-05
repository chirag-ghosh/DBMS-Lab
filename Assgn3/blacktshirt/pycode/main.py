import psycopg2
from config import config

def output_query_result(data_ret, columns_descr):
    for row in data_ret:
        for i in range(len(columns_descr)):
            row_str = row[i]
            col_str = columns_descr[i][0]
            print(col_str + " = ", end =" ")
            if (i == (len(columns_descr) - 1)):
                print(row_str)
            else:
                print(row_str, end=", ")

# menu
def main():
    # obtaining the configuration parameters
    conn = None
    try:
        params = config()
        # connecting to PostgreSQL database
        conn = psycopg2.connect(**params)
        # creating cursor object
        my_cursor = conn.cursor()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

    usr_choice = 0
    query_dict = {
        1: "SELECT T.name as Name FROM Physician as T, Trained_In as S, Procedure as R where T.EmployeeID=S.Physician and R.name='bypass surgery' and S.Treatment=R.code;",
        2: "SELECT all Phy.Name as Name FROM Physician Phy, Trained_in T, Affiliated_With A, Procedure P, Department D where Phy.EmployeeID = A.Physician and D.DepartmentID = A.Department and D.Name = 'cardiology' and Phy.EmployeeID = T.Physician and T.Treatment = P.Code and P.Name = 'bypass surgery';",
        3: "SELECT N.Name as Name FROM Nurse N, (SELECT M.EmployeeID as ID FROM Nurse M, On_Call OC, Room R where M.EmployeeID = OC.Nurse and OC.BlockFloor = R.BlockFloor and OC.BlockCode = R.BlockCode and R.Number = 123) as NurseOC where N.EmployeeID = NurseOC.ID;",
        4: "SELECT all P.Name as Name, P.Address as Address FROM Patient P, Prescribes Pre, Medication M WHERE M.Name = 'remdesivir' and Pre.Medication = M.Code and P.SSN = Pre.Patient;",
        5: "SELECT P.Name as \"Patient Name\", P.InsuranceID as InsuranceID FROM (SELECT Patient, SUM(\"End\" :: date - Start :: date) as stayCnt FROM Room R, Stay S WHERE S.Room = R.Number and R.Type = 'icu' GROUP BY Patient) as stayed, Patient P WHERE stayed.Patient = P.SSN and stayed.staycnt > 15;",
        6: "SELECT distinct N.Name as Name FROM Nurse N, Procedure P, Undergoes U WHERE U.Procedure = P.Code and P.Name = 'bypass surgery' and U.AssistingNurse = N.EmployeeID;",
        7: "SELECT N.Name as \"Nurse Name\", N.Position as \"Nurse Position\", Phy.Name as \"Physician Name\" FROM Physician Phy, Nurse N, Procedure P, Undergoes U WHERE U.Procedure = P.Code and P.Name = 'bypass surgery' and U.AssistingNurse = N.EmployeeID and U.Physician = Phy.EmployeeID;",
        8: "SELECT P.Name as Name FROM Physician P, (SELECT Physician, Procedure FROM Undergoes EXCEPT SELECT Physician, Treatment FROM Trained_In) as Phy WHERE Phy.Physician = P.EmployeeID;",
        9: "SELECT all P.Name as Name FROM Physician P, Undergoes U, Trained_in T WHERE P.EmployeeID = U.Physician and T.Physician = P.EmployeeID and U.Procedure = T.Treatment and U.Date :: date > T.CertificationExpires;",
        10: "SELECT all Phy.Name as \"Physician Name\", P.Name as \"Procedure Name\", U.Date :: date as \"Date of Procedure\", Patient.Name as \"Patient Name\" FROM Physician Phy, Undergoes U, Procedure P, Patient, Trained_in T WHERE Phy.EmployeeID = U.Physician and T.Physician = Phy.EmployeeID and U.Procedure = T.Treatment and U.Date > T.CertificationExpires and U.Patient = Patient.SSN and U.Procedure = P.Code;",
        11: "SELECT all P.Name as \"Patient Name\", Phy.Name as \"Patient's Physician\" FROM Physician Phy, Patient P WHERE Phy.EmployeeID = P.PCP and 5000 < (SELECT MAX(Proc.Cost) from Procedure Proc, Undergoes U WHERE P.SSN = U.Patient and Proc.Code = U.Procedure) and P.PCP IN (SELECT EmployeeID FROM Physician EXCEPT SELECT Head FROM Department) and (SELECT COUNT(distinct A.AppointmentID) FROM Appointment A, Department D, Affiliated_With AW WHERE AW.Department = D.DepartmentID and P.SSN = A.Patient and D.Name = 'cardiology' and AW.Physician = A.Physician) >= 2;",
        12: "SELECT M.Name as \"Medicine Name\", M.Brand as Brand FROM Medication M, (SELECT P.Medication as M1, count(distinct P.Patient) as Cnt FROM Prescribes P GROUP BY P.Medication) PrescribeCnt WHERE M.Code = PrescribeCnt.M1 and PrescribeCnt.Cnt = (SELECT Max(Cnt) as Cnt FROM (SELECT P1.Medication, count(distinct P1.Patient) as Cnt FROM Prescribes P1 GROUP BY P1.Medication) MostPrescribed);"
    }
    print("\nWelcome!\n")
    while True:  
        print("\nPlease select a query. Select 14 to exit!\n")
        print("1-> Names of all physicians who are trained in procedure name “bypass surgery”\n")
        print("2-> Names of all physicians affiliated with the department name “cardiology” and trained in “bypass surgery”\n")
        print("3-> Names of all the nurses who have ever been on call for room 123\n")
        print("4-> Names and addresses of all patients who were prescribed the medication named “remdesivir”\n")
        print("5-> Name and insurance id of all patients who stayed in the “icu” room type for more than 15 days\n")
        print("6-> Names of all nurses who assisted in the procedure name “bypass surgery”\n")
        print("7-> Name and position of all nurses who assisted in the procedure name “bypass surgery” along with the names of and the accompanying physicians\n")
        print("8-> Obtain the names of all physicians who have performed a medical procedure they have never been trained to perform\n")
        print("9-> Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)\n")
        print("10-> Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on\n")
        print("11-> Names of all patients (also include, for each patient, the name of the patient's physician), such that all the following are true:\n• The patient has been prescribed some medication by his/her physician\n• The patient has undergone a procedure with a cost larger that 5000\n• The patient has had at least two appointment where the physician was affiliated with the cardiology department\n• The patient's physician is not the head of any department\n")
        print("12-> Name and brand of the medication which has been prescribed to the highest number of patients\n")
        print("13-> Names of all physicians who are trained in procedure\n")
        print("14-> Exit\n")
 
        usr_choice = int(input())
        if(usr_choice == 14):  
            break  
        elif (usr_choice<1 or usr_choice>14):
            print("\n\nInvalid number entered. Please enter a valid choice!\n\n")
        elif(usr_choice == 13):
            print("Select a procedure from below: ")
            my_cursor.execute("SELECT Name as Procedure FROM Procedure;")
            data_ret = my_cursor.fetchall()
            columns_descr = my_cursor.description
            output_query_result(data_ret, columns_descr)
            print("Enter the name of the procedure : ")
            proc_name = input()
            my_cursor.execute("SELECT T.name as Name FROM Physician as T, Trained_In as S, Procedure as R where T.EmployeeID=S.Physician and R.name='" + proc_name + "' and S.Treatment=R.code;")
        else:
            my_cursor.execute(query_dict[usr_choice])
        data_ret = my_cursor.fetchall()
        columns_descr = my_cursor.description
        if columns_descr is None:
            print("\nNo output found for selected query!\n")
        else:
            output_query_result(data_ret, columns_descr)
        
    # closing the cursor and connection to server
    my_cursor.close()
    conn.close()
    print('Closed database connection')

if __name__=="__main__":
    main()