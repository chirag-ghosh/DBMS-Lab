#include <stdio.h>
#include <stdlib.h>
#include <string.h>


int main() {

    int usr_choice=-1;
    do{

        printf("\nWelcome!\n\nPlease select a query. Select 14 to exit!\n");
        printf("1-> Names of all physicians who are trained in procedure name “bypass surgery”\n");
        printf("2-> Names of all physicians affiliated with the department name “cardiology” and trained in “bypass surgery”\n");
        printf("3-> Names of all the nurses who have ever been on call for room 123\n");
        printf("4-> Names and addresses of all patients who were prescribed the medication named “remdesivir”\n");
        printf("5-> Name and insurance id of all patients who stayed in the “icu” room type for more than 15 days\n");
        printf("6-> Names of all nurses who assisted in the procedure name “bypass surgery”\n");
        printf("7-> Name and position of all nurses who assisted in the procedure name “bypass surgery” along with the names of and the accompanying physicians\n");
        printf("8-> Obtain the names of all physicians who have performed a medical procedure they have never been trained to perform\n");
        printf("9-> Names of all physicians who have performed a medical procedure that they are trained to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires)\n");
        printf("10-> Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on\n");
        printf("11-> Names of all patients (also include, for each patient, the name of the patient's physician), such that all the following are true:\n• The patient has been prescribed some medication by his/her physician\n• The patient has undergone a procedure with a cost larger that 5000\n• The patient has had at least two appointment where the physician was affiliated with the cardiology department\n• The patient's physician is not the head of any department\n");
        printf("12-> Name and brand of the medication which has been prescribed to the highest number of patients\n");
        printf("13-> Names of all physicians who are trained in procedure\n");
        printf("14-> Exit\n");

        scanf("%d", usr_choice);

        if(usr_choice<1 || usr_choice>14) {
            printf("Invalid number entered. Please enter a valid choice!\n");
        }
        if(usr_choice == 13){
            char proc_name[50];
            printf("Enter the name of the procedure : ");
            scanf("%s", proc_name);
        }

    }while(usr_choice != 14);
    
    return 0;
}
