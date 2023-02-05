# This Python script connects to a PostgreSQL database and utilizes Pandas to obtain data and create a data frame
# A initialization and configuration file is used to protect the author's login credentials

# import psycopg2
# import pandas as pd

# # Import the 'config' funtion from the config.py file
# from config import config

# # Establish a connection to the database by creating a cursor object

# # Obtain the configuration parameters
# params = config()
# # Connect to the PostgreSQL database
# conn = psycopg2.connect(**params)
# # Create a new cursor
# cur = conn.cursor()

# # A function that takes in a PostgreSQL query and outputs a pandas database 
# def create_pandas_table(sql_query, database = conn):
#     table = pd.read_sql_query(sql_query, database)
#     return table
  
# # Utilize the create_pandas_table function to create a Pandas data frame
# # Store the data as a variable
# vendor_info = create_pandas_table("SELECT T.name FROM Physician as T, Trained_In as S, Procedure as R where T.EmployeeID=S.Physician and R.name='bypass surgery' and S.Treatment=R.code;")
# vendor_info

# # Close the cursor and connection to so the server can allocate
# # bandwidth to other requests
# cur.close()
# conn.close()

# menu
def main():
    usr_choice = 0
    while True:  
        print("\nWelcome!\n\nPlease select a query. Select 14 to exit!\n")
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
            print("\n\n\nInvalid number entered. Please enter a valid choice!\n\n\n")
        elif(usr_choice == 13):
            print("Enter the name of the procedure : ")
            proc_name = input()

if __name__=="__main__":
    main()
