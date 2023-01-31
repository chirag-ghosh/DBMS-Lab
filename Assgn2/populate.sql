INSERT INTO
    Physician
VALUES
    (
        1,
        'Sarita Singhania',
        'Child Specialist',
        '696969699'
    );


INSERT INTO
    Physician
VALUES
    (2, 'Rajiv Tekriwal', 'Surgeon', '475839271');


INSERT INTO
    Physician
VALUES
    (3, 'Moulik Chavan', 'Psychologist', '987654321');


INSERT INTO
    Physician
VALUES
    (4, 'Mameer Matharth', 'Sexologist', '123456789');


INSERT INTO
    Department
VALUES
    (1, 'Cardiology', 2);


INSERT INTO
    Department
VALUES
    (2, 'Psychiatry', 3);


INSERT INTO
    Department
VALUES
    (3, 'Maternity', 1);


INSERT INTO
    Affiliated_With
VALUES
    (1, 3, TRUE);


INSERT INTO
    Affiliated_With
VALUES
    (2, 1, TRUE);


INSERT INTO
    Affiliated_With
VALUES
    (3, 2, TRUE);


INSERT INTO
    Affiliated_With
VALUES
    (4, 3, TRUE);


INSERT INTO
    PROCEDURE
VALUES
    (1, 'bypass surgery', 10000);


INSERT INTO
    PROCEDURE
VALUES
    (2, 'Vasectomy', 4000);


INSERT INTO
    PROCEDURE
VALUES
    (3, 'Hypnosis', 2000);


INSERT INTO
    PROCEDURE
VALUES
    (4, 'appendectomy', 6000);


INSERT INTO
    Trained_In
VALUES
    (1, 4, '2012-03-01', '2022-02-28');


INSERT INTO
    Trained_In
VALUES
    (4, 2, '2015-03-01', '2025-02-28');


INSERT INTO
    Trained_In
VALUES
    (3, 3, '2018-05-01', '2028-04-30');


INSERT INTO
    Trained_In
VALUES
    (2, 1, '2020-05-01', '2030-04-30');


INSERT INTO
    Trained_In
VALUES
    (1, 3, '2020-05-01', '2030-04-30');


INSERT INTO
    Trained_In
VALUES
    (4, 1, '2017-05-01', '2027-04-30');


INSERT INTO
    Patient
VALUES
    (
        111111111,
        'Chhavi Deshmukh',
        'Deshmukh Lane, Imaginary City, Galactus',
        '9472482913',
        65734,
        2
    );


INSERT INTO
    Patient
VALUES
    (
        222222222,
        'Danyan Ujjain',
        'Daydreamers Garden, Tafpas Land',
        '8392046578',
        36292,
        3
    );


INSERT INTO
    Patient
VALUES
    (
        333333333,
        'Saurav Bharti',
        'Daydreamers Garden, Tafpas Land',
        '9274921674',
        82732,
        3
    );


INSERT INTO
    Patient
VALUES
    (
        444444444,
        'Dev Garg',
        'Singer Street, VS District',
        '9829320897',
        27189,
        1
    );


INSERT INTO
    Patient
VALUES
    (
        555555555,
        'Chukka',
        'Sins Avenue, VS District',
        '8594672847',
        53483,
        4
    );


INSERT INTO
    Nurse
VALUES
    (51, 'Aritra Dhar', 'Head Nurse', TRUE, 767676761);


INSERT INTO
    Nurse
VALUES
    (52, 'Ikshita Das', 'Nurse', TRUE, 585858586);


INSERT INTO
    Nurse
VALUES
    (53, 'Umang Sen', 'Nurse', TRUE, 858585859);


INSERT INTO
    Appointment
VALUES
    (
        1,
        222222222,
        NULL,
        3,
        '2023-01-30 10:00',
        '2023-01-30 12:00',
        'NC-241'
    );


INSERT INTO
    Appointment
VALUES
    (
        2,
        444444444,
        51,
        1,
        '2023-02-01 09:00',
        '2023-02-01 10:00',
        'NR-441'
    );


INSERT INTO
    Appointment
VALUES
    (
        3,
        555555555,
        NULL,
        4,
        '2023-02-01 11:00',
        '2023-02-01 12:00',
        'NR-441'
    );


INSERT INTO
    Medication
VALUES
    (1, 'remdesivir', 'softy labs', 'NA');


INSERT INTO
    Medication
VALUES
    (2, 'paracetamol', 'AGB Enterprises', 'Fever');


INSERT INTO
    Medication
VALUES
    (3, 'aspirin', 'AGB Enterprises', 'Heart Attack');


INSERT INTO
    Prescribes
VALUES
    (3, 222222222, 1, '2023-01-30 11:52', 1, '10');


INSERT INTO
    Prescribes
VALUES
    (3, 333333333, 1, '2023-01-28 10:23', NULL, '10');


INSERT INTO
    Prescribes
VALUES
    (1, 444444444, 3, '2023-01-25 11:49', NULL, '15');


INSERT INTO
    Block
VALUES
    (1, 1);


INSERT INTO
    Block
VALUES
    (1, 2);


INSERT INTO
    Block
VALUES
    (2, 2);


INSERT INTO
    Block
VALUES
    (2, 1);


INSERT INTO
    Room
VALUES
    (1, 'NC', 1, 1, False);


INSERT INTO
    Room
VALUES
    (2, 'NR', 1, 2, False);


INSERT INTO
    Room
VALUES
    (3, 'NR', 1, 2, TRUE);


INSERT INTO
    Room
VALUES
    (4, 'icu', 2, 1, False);


INSERT INTO
    Room
VALUES
    (123, 'icu', 2, 2, False);


INSERT INTO
    On_Call
VALUES
    (51, 2, 1, '2023-01-30 08:00', '2023-01-30 20:00');


INSERT INTO
    On_Call
VALUES
    (51, 2, 2, '2023-01-31 08:00', '2023-01-31 20:00');


INSERT INTO
    On_Call
VALUES
    (52, 1, 1, '2023-01-30 08:00', '2023-01-30 20:00');


INSERT INTO
    On_Call
VALUES
    (53, 1, 2, '2023-01-30 08:00', '2023-01-30 20:00');


INSERT INTO
    Stay
VALUES
    (
        1,
        444444444,
        4,
        '2023-01-25 10:00',
        '2023-02-15 12:00'
    );


INSERT INTO
    Stay
VALUES
    (
        2,
        555555555,
        1,
        '2023-01-26 10:00',
        '2023-01-26 22:00'
    );


INSERT INTO
    Stay
VALUES
    (
        3,
        111111111,
        3,
        '2023-01-22 12:00',
        '2023-01-24 17:00'
    );


INSERT INTO
    Undergoes
VALUES
    (555555555, 2, 2, '2023-01-26', 4, 51);


INSERT INTO
    Undergoes
VALUES
    (444444444, 1, 1, '2023-01-30', 2, 52);


INSERT INTO
    Undergoes
VALUES
    (111111111, 3, 3, '2023-01-22', 3, NULL);