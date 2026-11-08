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