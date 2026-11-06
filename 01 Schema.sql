-- ==========================================
-- CPU4:103 INTRODUCTION TO DATABASES
-- PART B - AAMNA'S CONTRIBUTION
-- Patient, Specialty, Clinician, Clinic
-- ==========================================

-- Step 1: Create the hospital database
CREATE DATABASE IF NOT EXISTS CrownfieldEyeHospital;

-- Step 2: Select the database
USE CrownfieldEyeHospital;

-- Step 3: Verify the selected database
SELECT DATABASE();

-- 1. CREATE PATIENT TABLE
-- =======================

-- Step 4: Create the Patient table
CREATE TABLE Patient (
    PatientID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Postcode VARCHAR(10) NOT NULL
);

-- Step 5: Check that the Patient table exists
DESCRIBE Patient;

-- 2. CREATE SPECIALTY TABLE
-- ==========================

-- Step 6: Create the Specialty table
CREATE TABLE Specialty (
    SpecialtyID INT PRIMARY KEY,
    SpecialtyName VARCHAR(100) NOT NULL UNIQUE
);

-- Step 7: Check the Specialty table structure
DESCRIBE Specialty;

-- 3. CREATE CLINICIAN TABLE
-- ===========================

-- Step 8: Create the Clinician table
CREATE TABLE Clinician (
    ClinicianID INT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    SpecialtyID INT NOT NULL,
    FOREIGN KEY (SpecialtyID)
        REFERENCES Specialty(SpecialtyID)
);

-- Step 9: Check the Clinician table structure
DESCRIBE Clinician;

-- Check the foreign key constraint
SHOW CREATE TABLE Clinician;

-- 4. CREATE CLINIC TABLE
-- ========================

-- Step 10: Create the Clinic table
CREATE TABLE Clinic (
    ClinicID INT PRIMARY KEY,
    ClinicName VARCHAR(100) NOT NULL UNIQUE
);

-- Step 11: Check the Clinic table structure
DESCRIBE Clinic;


-- Step 12: Insert 10 synthetic  specialties
INSERT INTO Specialty (SpecialtyID, SpecialtyName)
VALUES
(1, 'Glaucoma'),
(2, 'Retina'),
(3, 'Cornea'),
(4, 'Cataract'),
(5, 'Paediatric Ophthalmology'),
(6, 'Oculoplastics'),
(7, 'Neuro-Ophthalmology'),
(8, 'Uveitis'),
(9, 'Medical Retina'),
(10, 'Emergency Eye Care');

-- Step 13: Verify the inserted specialties
SELECT * FROM Specialty;

-- Step 14: Count the specialty records
SELECT COUNT(*) AS TotalSpecialties FROM Specialty;


-- Step 15: Insert 10 synthetic clinic records
INSERT INTO Clinic (ClinicID, ClinicName)
VALUES
(1, 'City Road Eye Clinic'),
(2, 'Bedford Eye Clinic'),
(3, 'Croydon Eye Clinic'),
(4, 'Riverside Eye Clinic'),
(5, 'Northgate Eye Clinic'),
(6, 'Westfield Eye Clinic'),
(7, 'Meadow Park Eye Clinic'),
(8, 'Central Eye Clinic'),
(9, 'Oakwood Eye Clinic'),
(10, 'Lakeside Eye Clinic');

-- Step 16: Verify clinic records
SELECT * FROM Clinic;

-- Step 17: Count clinic records
SELECT COUNT(*) AS TotalClinics FROM Clinic;


-- Step 18: Insert 10 synthetic patient records
INSERT INTO Patient (PatientID, FirstName, LastName, Postcode)
VALUES
(1, 'Oliver', 'Bennett', 'AB1 2CD'),
(2, 'Amelia', 'Carter', 'BC2 3DE'),
(3, 'George', 'Wilson', 'CD3 4EF'),
(4, 'Isla', 'Thompson', 'DE4 5FG'),
(5, 'Arthur', 'Robinson', 'EF5 6GH'),
(6, 'Ava', 'Walker', 'FG6 7HJ'),
(7, 'Leo', 'Wright', 'GH7 8JK'),
(8, 'Freya', 'Hall', 'HJ8 9KL'),
(9, 'Noah', 'Green', 'KL9 1MN'),
(10, 'Grace', 'Baker', 'MN1 2PQ');


-- Step 19: Display the patient records
SELECT * FROM Patient;


-- Step 20: Count the patient records
SELECT COUNT(*) AS TotalPatients FROM Patient;


-- Step 21: Insert 10 synthetic  clinician records
INSERT INTO Clinician
    (ClinicianID, FirstName, LastName, SpecialtyID)
VALUES
    (1, 'James', 'Hughes', 1),
    (2, 'Sarah', 'Mitchell', 2),
    (3, 'Daniel', 'Evans', 3),
    (4, 'Emily', 'Collins', 4),
    (5, 'Thomas', 'Edwards', 5),
    (6, 'Charlotte', 'Stewart', 6),
    (7, 'William', 'Morris', 7),
    (8, 'Sophie', 'Rogers', 8),
    (9, 'Henry', 'Cook', 9),
    (10, 'Lucy', 'Morgan', 10);


-- Step 22: Display clinician records
SELECT * FROM Clinician;


-- Step 23: Count clinician records
SELECT COUNT(*) AS TotalClinicians FROM Clinician;


-- ==============
-- 1. INNER JOIN
-- ==============

-- Step 24: Display clinicians with their specialties
SELECT
    c.ClinicianID,
    c.FirstName,
    c.LastName,
    s.SpecialtyName
FROM Clinician AS c
INNER JOIN Specialty AS s
    ON c.SpecialtyID = s.SpecialtyID;


-- Step 25: Count clinic records
SELECT COUNT(*) AS TotalClinics FROM Clinic;


-- Step 26: Verify all four tables

SELECT 'Patient' AS TableName, COUNT(*) AS TotalRecords
FROM Patient

UNION ALL

SELECT 'Specialty', COUNT(*)
FROM Specialty

UNION ALL

SELECT 'Clinician', COUNT(*)
FROM Clinician

UNION ALL

SELECT 'Clinic', COUNT(*)
FROM Clinic;

USE CrownfieldEyeHospital;

SELECT
    a.AppointmentID,
    a.AppointmentDate,
    a.AppointmentTime,
    fp.FollowUpID,
    fp.DueDate,
    fp.Priority,
    fp.Status
FROM Appointment AS a
LEFT JOIN FollowUpPlan AS fp
    ON a.AppointmentID = fp.AppointmentID
WHERE fp.FollowUpID IS NULL
ORDER BY a.AppointmentID;

-- =======================
-- 2. DEFAULT CONSTRAINT
-- =======================

-- Step 27: Add a clinic status with a DEFAULT constraint
ALTER TABLE Clinic
ADD COLUMN ClinicStatus VARCHAR(20)
NOT NULL DEFAULT 'Active';

-- Step 28: Check the updated Clinic table
DESCRIBE Clinic;

-- Step 29: Display existing clinic records
SELECT * FROM Clinic;


-- Step 30: Test the DEFAULT constraint
INSERT INTO Clinic (ClinicID, ClinicName) VALUES (11, 'Test Eye Clinic');

-- Step 31: Update the temporary test clinic
UPDATE Clinic SET ClinicStatus = 'Inactive' WHERE ClinicID = 11;

-- Verify the update
SELECT * FROM Clinic WHERE ClinicID = 11;

-- ================================
-- 3. DELETE TEMPORARY TEST CLINIC
-- ================================

-- Step 32: Delete the temporary test clinic
DELETE FROM Clinic WHERE ClinicID = 11;

-- Verify that the temporary record has been deleted
SELECT * FROM Clinic WHERE ClinicID = 11;


-- Step 33: Remove the temporary test column
ALTER TABLE Clinic DROP COLUMN ClinicStatus;

-- Verify the original table structure
DESCRIBE Clinic;

-- Confirm the original 10 clinic records remain
SELECT COUNT(*) AS TotalClinics FROM Clinic;


-- ==========================================
-- CPU4:103 INTRODUCTION TO DATABASES
-- PART B - KHALID'S CONTRIBUTION
-- Patient, Specialty, Clinician, Clinic
-- ==========================================

USE CrownfieldEyeHospital;

-- 5. CREATE APPOINTMENT TABLE
-- ===========================

CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY,
    PatientID INT NOT NULL,
    ClinicianID INT NOT NULL,
    ClinicID INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,

    -- Link appointments to existing records
    FOREIGN KEY (PatientID)
        REFERENCES Patient(PatientID),

    FOREIGN KEY (ClinicianID)
        REFERENCES Clinician(ClinicianID),

    FOREIGN KEY (ClinicID)
        REFERENCES Clinic(ClinicID)
);

-- Verify the table structure
DESCRIBE Appointment;


-- Step 2: Insert 10 synthetic appointment records
INSERT INTO Appointment
    (AppointmentID, PatientID, ClinicianID, ClinicID,
     AppointmentDate, AppointmentTime)
VALUES
(1, 1, 1, 1, '2026-11-02', '09:00:00'),
(2, 2, 2, 2, '2026-11-02', '09:30:00'),
(3, 3, 3, 3, '2026-11-03', '10:00:00'),
(4, 4, 4, 4, '2026-11-03', '10:30:00'),
(5, 5, 5, 5, '2026-11-04', '11:00:00'),
(6, 6, 6, 6, '2026-11-04', '11:30:00'),
(7, 7, 7, 7, '2026-11-05', '12:00:00'),
(8, 8, 8, 8, '2026-11-05', '13:00:00'),
(9, 9, 9, 9, '2026-11-06', '14:00:00'),
(10, 10, 10, 10, '2026-11-06', '15:00:00');

-- Step 3: Verify appointment records
SELECT * FROM Appointment;

-- Step 4: Count appointment records
SELECT COUNT(*) AS TotalAppointments FROM Appointment;

-- 6. CREATE DIAGNOSIS TABLE
-- ==========================

-- Step 5: Create the Diagnosis table
CREATE TABLE Diagnosis (
    DiagnosisID INT PRIMARY KEY,
    DiagnosisName VARCHAR(150) NOT NULL UNIQUE
);

-- Verify the table structure
DESCRIBE Diagnosis;


-- Step 6: Insert 10 diagnosis records
INSERT INTO Diagnosis (DiagnosisID, DiagnosisName)
VALUES
(1, 'Ocular hypertension'),
(2, 'Diabetic macular oedema'),
(3, 'Glaucoma suspect'),
(4, 'Keratoconus'),
(5, 'Cataract'),
(6, 'Dry eye disease'),
(7, 'Retinal detachment'),
(8, 'Uveitis'),
(9, 'Conjunctivitis'),
(10, 'Age-related macular degeneration');

-- Step 7: Display diagnosis records
SELECT * FROM Diagnosis;

-- Step 8: Count diagnosis records
SELECT COUNT(*) AS TotalDiagnoses FROM Diagnosis;

-- 7. CREATE APPOINTMENT_DIAGNOSIS TABLE
-- ======================================

-- Step 7: Create the Appointment_Diagnosis junction table
CREATE TABLE Appointment_Diagnosis (
    AppointmentID INT NOT NULL,
    DiagnosisID INT NOT NULL,

    -- Composite primary key
    PRIMARY KEY (AppointmentID, DiagnosisID),

    -- Link to the Appointment table
    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID),

    -- Link to the Diagnosis table
    FOREIGN KEY (DiagnosisID)
        REFERENCES Diagnosis(DiagnosisID)
);

-- Verify the table structure
DESCRIBE Appointment_Diagnosis;


-- Step 8: Link appointments to diagnoses
INSERT INTO Appointment_Diagnosis (AppointmentID, DiagnosisID)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Step 9: Display the links
SELECT * FROM Appointment_Diagnosis;

-- Step 10: Count the links
SELECT COUNT(*) AS TotalAppointmentDiagnosis FROM Appointment_Diagnosis;

-- 8. CREATE PRESCRIPTION TABLE
-- =============================

-- Step 9: Create the Prescription table
CREATE TABLE Prescription (
    PrescriptionID INT PRIMARY KEY,
    AppointmentID INT NOT NULL,
    PrescriptionDate DATE NOT NULL,

    -- Link each prescription to an existing appointment
    FOREIGN KEY (AppointmentID)
        REFERENCES Appointment(AppointmentID)
);

-- Verify the table structure
DESCRIBE Prescription;


-- Step 10: Insert 10 prescription records
INSERT INTO Prescription
    (PrescriptionID, AppointmentID, PrescriptionDate)
VALUES
(1, 1, '2026-11-02'),
(2, 2, '2026-11-02'),
(3, 3, '2026-11-03'),
(4, 4, '2026-11-03'),
(5, 5, '2026-11-04'),
(6, 6, '2026-11-04'),
(7, 7, '2026-11-05'),
(8, 8, '2026-11-05'),
(9, 9, '2026-11-06'),
(10, 10, '2026-11-06');

-- Step 11: Display prescription records
SELECT * FROM Prescription;

-- Step 12: Count prescription records
SELECT COUNT(*) AS TotalPrescriptions FROM Prescription;


USE CrownfieldEyeHospital;

SELECT 'Appointment' AS TableName, COUNT(*) AS TotalRecords
FROM Appointment

UNION ALL

SELECT 'Diagnosis', COUNT(*)
FROM Diagnosis

UNION ALL

SELECT 'Appointment_Diagnosis', COUNT(*)
FROM Appointment_Diagnosis

UNION ALL

SELECT 'Prescription', COUNT(*)
FROM Prescription;

-- ==============
-- 1. INNER JOIN
-- ==============

SELECT
    a.AppointmentID,
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    c.FirstName AS ClinicianFirstName,
    cl.ClinicName,
    a.AppointmentDate,
    a.AppointmentTime
FROM Appointment a
INNER JOIN Patient p
    ON a.PatientID = p.PatientID
INNER JOIN Clinician c
    ON a.ClinicianID = c.ClinicianID
INNER JOIN Clinic cl
    ON a.ClinicID = cl.ClinicID;


SELECT
    p.PrescriptionID,
    p.PrescriptionDate,
    a.AppointmentID,
    a.AppointmentDate,
    pt.FirstName AS PatientFirstName,
    pt.LastName AS PatientLastName
FROM Prescription p
INNER JOIN Appointment a
    ON p.AppointmentID = a.AppointmentID
INNER JOIN Patient pt
    ON a.PatientID = pt.PatientID;

SELECT
    a.AppointmentID,
    d.DiagnosisID,
    d.DiagnosisName,
    a.AppointmentDate
FROM Appointment a
INNER JOIN Appointment_Diagnosis ad
    ON a.AppointmentID = ad.AppointmentID
INNER JOIN Diagnosis d
    ON ad.DiagnosisID = d.DiagnosisID;


-- ==========
-- 2. INSERT
-- ==========

INSERT INTO Appointment
    (AppointmentID, PatientID, ClinicianID, ClinicID,
     AppointmentDate, AppointmentTime)
VALUES
    (11, 999, 1, 1, '2026-11-07', '09:00:00');

SELECT COUNT(*) AS TotalAppointments FROM Appointment;


SELECT 'Appointment' AS TableName, COUNT(*) AS TotalRecords FROM Appointment

UNION ALL

SELECT 'Diagnosis', COUNT(*)
FROM Diagnosis

UNION ALL

SELECT 'Appointment_Diagnosis', COUNT(*)
FROM Appointment_Diagnosis

UNION ALL

SELECT 'Prescription', COUNT(*)
FROM Prescription;


USE CrownfieldEyeHospital;

UPDATE Appointment
SET AppointmentTime = '09:15:00'
WHERE AppointmentID = 1;

SELECT AppointmentID, AppointmentDate, AppointmentTime
FROM Appointment
WHERE AppointmentID = 1;

INSERT INTO Appointment
    (AppointmentID, PatientID, ClinicianID, ClinicID,
     AppointmentDate, AppointmentTime)
VALUES
    (11, 1, 1, 1, '2026-11-07', '16:00:00');

-- =======================================
-- 3. DELETE TEMPORARY TEST APPOINTMENTID
-- =======================================

SELECT *
FROM Appointment
WHERE AppointmentID = 11;

DELETE FROM Appointment WHERE AppointmentID = 11;

SELECT * FROM Appointment WHERE AppointmentID = 11;


-- ==========================================
-- CPU4:103 INTRODUCTION TO DATABASES
-- PART B - FARHAN'S CONTRIBUTION
-- Medicine, Prescription_Item, FollowUpPlan
-- ==========================================

USE CrownfieldEyeHospital;

-- 9. CREATE MEDICINE TABLE
-- =========================

CREATE TABLE Medicine (
    medicine_id INT PRIMARY KEY,
    MedicineName VARCHAR(100) NOT NULL,
    Strength VARCHAR(50) NOT NULL,
    MedicineType VARCHAR(50) NOT NULL,
    Manufacturer VARCHAR(100),
    UNIQUE (MedicineName, Strength)
);

INSERT INTO Medicine
(medicine_id, medicineName, strength, medicineType, manufacturer)
VALUES
(1,'Latanoprost','0.005%','Eye Drops','Pharma A'),
(2,'Timolol','0.5%','Eye Drops','Pharma B'),
(3,'Aflibercept','2mg','Injection','Pharma C'),
(4,'Sodium Chloride','5%','Eye Drops','Pharma D'),
(5,'Dorzolamide','2%','Eye Drops','Pharma E'),
(6,'Brimonidine','0.2%','Eye Drops','Pharma F'),
(7,'Prednisolone','1%','Eye Drops','Pharma G'),
(8,'Cyclopentolate','1%','Eye Drops','Pharma H'),
(9,'Tropicamide','0.5%','Eye Drops','Pharma I'),
(10,'Carboxymethylcellulose','0.5%','Eye Drops','Pharma J');

DESCRIBE Medicine;

SELECT * FROM Medicine;


-- 10. CREATE PRESCRIPTION_ITEM TABLE
-- ==================================

CREATE TABLE Prescription_Item (
    PrescriptionItemID INT PRIMARY KEY,
    PrescriptionID INT NOT NULL,
    medicine_id INT NOT NULL,
    Dosage VARCHAR(50) NOT NULL,
    Route VARCHAR(50) NOT NULL,
    Frequency VARCHAR(100) NOT NULL,
    Duration VARCHAR(50) NOT NULL,

    FOREIGN KEY (PrescriptionID)
    REFERENCES Prescription(PrescriptionID),

    FOREIGN KEY (medicine_id)
    REFERENCES Medicine(medicine_id)
);


INSERT INTO Prescription_Item
    (PrescriptionItemID, PrescriptionID, medicine_id,
     Dosage, Route, Frequency, Duration)
VALUES
(1, 1, 1, '1 drop', 'Ophthalmic', 'Once daily', '6 weeks'),
(2, 2, 2, '1 drop', 'Ophthalmic', 'Twice daily', '4 weeks'),
(3, 3, 3, '2mg', 'Intravitreal', 'As prescribed', 'Monthly'),
(4, 4, 4, '1 drop', 'Ophthalmic', 'Three times daily', '8 weeks'),
(5, 5, 5, '1 drop', 'Ophthalmic', 'Twice daily', '6 weeks'),
(6, 6, 6, '1 drop', 'Ophthalmic', 'Twice daily', '4 weeks'),
(7, 7, 7, '1 drop', 'Ophthalmic', 'Four times daily', '2 weeks'),
(8, 8, 8, '1 drop', 'Ophthalmic', 'As prescribed', '1 week'),
(9, 9, 9, '1 drop', 'Ophthalmic', 'As prescribed', '1 day'),
(10, 10, 10, '1 drop', 'Ophthalmic', 'Three times daily', '4 weeks');

SELECT * FROM Prescription_Item;

SELECT COUNT(*) AS TotalPrescriptionItems FROM Prescription_Item;

SELECT * FROM Prescription;
SELECT * FROM Medicine;
SELECT * FROM Prescription_Item;


-- 11. CREATE FOLLOWUPPLAN TABLE
-- =============================

CREATE TABLE FollowUpPlan (
    FollowUpID INT PRIMARY KEY,
    AppointmentID INT NOT NULL UNIQUE,
    DueDate DATE NOT NULL,
    Priority VARCHAR(20) NOT NULL DEFAULT 'Routine',
    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',
    Notes VARCHAR(255),

    FOREIGN KEY (AppointmentID)
    REFERENCES Appointment(AppointmentID),

    CHECK (Priority IN ('Low', 'Routine', 'High', 'Urgent')),
    CHECK (Status IN ('Pending', 'Completed', 'Cancelled'))
);

-- INSERT 10 FOLLOW-UP PLANS

INSERT INTO FollowUpPlan
    (FollowUpID, AppointmentID, DueDate, Priority, Status, Notes) VALUES
(1, 1, '2026-11-16', 'High', 'Pending', 'Review eye pressure'),
(2, 2, '2026-11-02', 'Urgent', 'Pending', 'OCT scan review'),
(3, 3, '2026-12-01', 'Routine', 'Pending', 'Visual field test'),
(4, 4, '2026-12-07', 'Routine', 'Pending', 'Corneal topography'),
(5, 5, '2026-11-20', 'High', 'Pending', 'Glaucoma assessment'),
(6, 6, '2026-11-25', 'Routine', 'Pending', 'Retina examination'),
(7, 7, '2026-12-10', 'Low', 'Pending', 'General eye review'),
(8, 8, '2026-11-30', 'High', 'Pending', 'Medication review'),
(9, 9, '2026-12-15', 'Routine', 'Pending', 'Vision assessment'),
(10, 10, '2026-12-20', 'Low', 'Pending', 'Follow-up consultation');

SELECT * FROM FollowUpPlan;

SELECT COUNT(*) AS TotalFollowUpPlans FROM FollowUpPlan;

-- =========================================
-- 1. CONTROLLED UPDATE
-- =========================================

UPDATE FollowUpPlan
SET Status = 'Completed'
WHERE FollowUpID = 1;

SELECT * FROM FollowUpPlan
WHERE FollowUpID = 1;


-- =========================================
-- 2. CONTROLLED DELETE
-- =========================================

DELETE FROM FollowUpPlan
WHERE FollowUpID = 10;

SELECT * FROM FollowUpPlan
WHERE FollowUpID = 10;

INSERT INTO FollowUpPlan
(FollowUpID, AppointmentID, DueDate, Priority, Status, Notes)
VALUES
(10, 10, '2026-12-20', 'Low', 'Pending', 'Follow-up consultation');

SELECT * FROM FollowUpPlan;

SELECT COUNT(*) AS TotalRecords
FROM FollowUpPlan;

-- =========================================
-- 3. FINAL VERIFICATION
-- =========================================

SELECT COUNT(*) AS TotalMedicines
FROM Medicine;

SELECT COUNT(*) AS TotalPrescriptionItems
FROM Prescription_Item;

SELECT COUNT(*) AS TotalFollowUpPlans
FROM FollowUpPlan;


-- =================
-- CHECK ALL TABLES
-- =================

SHOW TABLES;



