
-- =======================================================
-- PART D (Task 1): SECURITY CONTROLS
-- G1432252_Aamna: Create Administrator and Doctor roles
-- =======================================================


USE CrownfieldEyeHospital;


-- STEP 1: CREATING ROLES
-- =======================

CREATE ROLE IF NOT EXISTS
    'HospitalAdministrator',
    'Doctor';

-- Check that the roles have been created
SELECT *
FROM mysql.user
WHERE User IN ('HospitalAdministrator', 'Doctor');


-- STEP 2: ASSIGN PRIVILEGES TO THE TWO ROLES
-- =============================================

USE CrownfieldEyeHospital;

-- Administrator: full control of the hospital database
GRANT ALL PRIVILEGES
ON CrownfieldEyeHospital.*
TO 'HospitalAdministrator';

-- Doctor: view, insert and update records
-- No DELETE permission is granted

GRANT SELECT, INSERT, UPDATE
ON CrownfieldEyeHospital.*
TO 'Doctor';

-- Check the Administrator permissions
SHOW GRANTS FOR 'HospitalAdministrator';

-- Check the Doctor permissions
SHOW GRANTS FOR 'Doctor';


-- STEP 3: CREATE DATABASE USER ACCOUNTS
-- ======================================

USE CrownfieldEyeHospital;

-- Create an administrator account
CREATE USER IF NOT EXISTS
'hospital_admin'@'localhost'
IDENTIFIED BY 'Admin#ChangeMe2026!';

-- Create a doctor account
CREATE USER IF NOT EXISTS
'doctor_user'@'localhost'
IDENTIFIED BY 'Doctor#ChangeMe2026!';

-- Assign the appropriate roles
GRANT 'HospitalAdministrator'
TO 'hospital_admin'@'localhost';

GRANT 'Doctor'
TO 'doctor_user'@'localhost';

-- Make the roles active by default
SET DEFAULT ROLE ALL
TO 'hospital_admin'@'localhost';

SET DEFAULT ROLE ALL
TO 'doctor_user'@'localhost';

-- Verify role assignments

SHOW GRANTS FOR 'hospital_admin'@'localhost';

SHOW GRANTS FOR 'doctor_user'@'localhost';


-- =======================================================
-- PART D (Task 1): SECURITY CONTROLS
-- G1432240_Khalid: Create Receptionist and Patient roles
-- =======================================================

USE CrownfieldEyeHospital;


-- Create Receptionist and Patient roles

CREATE ROLE IF NOT EXISTS 'Receptionist';

CREATE ROLE IF NOT EXISTS 'Patient';

-- Permissions for Receptionist

GRANT SELECT, INSERT, UPDATE
ON CrownfieldEyeHospital.Appointment
TO 'Receptionist';

GRANT SELECT
ON CrownfieldEyeHospital.Patient
TO 'Receptionist';

GRANT SELECT
ON CrownfieldEyeHospital.Clinician
TO 'Receptionist';

GRANT SELECT
ON CrownfieldEyeHospital.Clinic
TO 'Receptionist';

-- Permissions for Patient

GRANT SELECT
ON CrownfieldEyeHospital.Patient
TO 'Patient';

GRANT SELECT
ON CrownfieldEyeHospital.Appointment
TO 'Patient';

-- Check Receptionist permissions
SHOW GRANTS FOR 'Receptionist';

-- Check Patient permissions
SHOW GRANTS FOR 'Patient';

-- TASK D1: CHECK EXISTING MYSQL USERS

SELECT user, host FROM mysql.user;

-- Create a test login account for Receptionist

CREATE USER IF NOT EXISTS 'receptionist_test'@'localhost'
IDENTIFIED BY 'Receptionist@123';

GRANT 'Receptionist' TO 'receptionist_test'@'localhost';

SET DEFAULT ROLE 'Receptionist'
TO 'receptionist_test'@'localhost';

-- Create a test login account for Patient

CREATE USER IF NOT EXISTS 'patient_test'@'localhost'
IDENTIFIED BY 'Patient@123';

GRANT 'Patient' TO 'patient_test'@'localhost';

SET DEFAULT ROLE 'Patient'
TO 'patient_test'@'localhost';

-- Verify Receptionist test account
SHOW GRANTS FOR 'receptionist_test'@'localhost';

-- Verify Patient test account
SHOW GRANTS FOR 'patient_test'@'localhost';


-- =========================================================
-- PART D (Task D2): SECURITY CONTROLS
-- G1432689_Farhan: Demonstrating SHA-256 password hashing
-- =========================================================


USE CrownfieldEyeHospital;
SELECT DATABASE();


-- D2: Demonstrating SHA-256 password hashing

SELECT
    SHA2('HospitalDemo2026!', 256) AS HashedPassword;


    -- D2: Verify that the correct password matches its hash

SELECT
    CASE
        WHEN SHA2('HospitalDemo2026!', 256) =
             SHA2('HospitalDemo2026!', 256)
        THEN 'Password Matched'
        ELSE 'Password Not Matched'
    END AS PasswordVerification;


    -- D2: Verify an incorrect password

SELECT
    CASE
        WHEN SHA2('WrongPassword123', 256) =
             SHA2('HospitalDemo2026!', 256)
        THEN 'Password Matched'
        ELSE 'Password Not Matched'
    END AS PasswordVerification;


    -- D2: Create a demonstration table for password hashes

CREATE TABLE IF NOT EXISTS PasswordSecurityDemo (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash CHAR(64) NOT NULL
);

-- D2: Store a fictional user's hashed password

INSERT INTO PasswordSecurityDemo
    (UserID, Username, PasswordHash)
VALUES
    (1, 'TestDoctor', SHA2('HospitalDemo2026!', 256));


    -- D2: Verify password against the stored hash

SELECT
    Username,
    CASE
        WHEN PasswordHash = SHA2('HospitalDemo2026!', 256)
        THEN 'Password Matched'
        ELSE 'Password Not Matched'
    END AS VerificationResult
FROM PasswordSecurityDemo
WHERE Username = 'TestDoctor';


-- D2: Test an incorrect password against the stored hash

SELECT
    Username,
    CASE
        WHEN PasswordHash = SHA2('WrongPassword123', 256)
        THEN 'Password Matched'
        ELSE 'Password Not Matched'
    END AS VerificationResult
FROM PasswordSecurityDemo
WHERE Username = 'TestDoctor';


-- D2: Verify that only the password hash is stored

SELECT
    UserID,
    Username,
    PasswordHash
FROM PasswordSecurityDemo;






