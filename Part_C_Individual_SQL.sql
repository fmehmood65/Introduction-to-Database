-- Crownfield Eye Hospital - Part C: Individual SQL and Validation
-- Reconstructed from the SQL screenshots in the submitted Word report.
-- Requires the existing CrownfieldEyeHospital schema and its Part B sample data.
USE CrownfieldEyeHospital;

-- C1: Aggregate query (GROUP BY and HAVING)
SELECT
    c.ClinicianID,
    c.FirstName,
    c.LastName,
    s.SpecialtyName,
    COUNT(a.AppointmentID) AS TotalAppointments
FROM Clinician c
INNER JOIN Specialty s ON c.SpecialtyID = s.SpecialtyID
INNER JOIN Appointment a ON c.ClinicianID = a.ClinicianID
GROUP BY c.ClinicianID, c.FirstName, c.LastName, s.SpecialtyName
HAVING COUNT(a.AppointmentID) >= 1;

-- C2: INNER JOIN - prescription and treatment details
SELECT
    pr.PrescriptionID,
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    c.FirstName AS ClinicianFirstName,
    c.LastName AS ClinicianLastName,
    m.MedicineName,
    m.Strength,
    pi.Dosage,
    pi.Frequency,
    pi.Duration
FROM Prescription pr
INNER JOIN Appointment a ON pr.AppointmentID = a.AppointmentID
INNER JOIN Patient p ON a.PatientID = p.PatientID
INNER JOIN Clinician c ON a.ClinicianID = c.ClinicianID
INNER JOIN Prescription_Item pi ON pr.PrescriptionID = pi.PrescriptionID
INNER JOIN Medicine m ON pi.medicine_id = m.medicine_id;

-- C3: LEFT JOIN - patients with no appointments
SELECT
    p.PatientID,
    p.FirstName,
    p.LastName,
    a.AppointmentID,
    a.AppointmentDate
FROM Patient p
LEFT JOIN Appointment a ON p.PatientID = a.PatientID
WHERE a.AppointmentID IS NULL;

-- C4: Subquery - latest scheduled appointment date
SELECT
    AppointmentID,
    PatientID,
    ClinicianID,
    AppointmentDate,
    AppointmentTime
FROM Appointment
WHERE AppointmentDate = (
    SELECT MAX(AppointmentDate)
    FROM Appointment
);

-- C5: Stored procedure - patient appointments
-- DROP allows this script to be rerun without a duplicate-procedure error.
DROP PROCEDURE IF EXISTS GetPatientAppointments;
DELIMITER $$
CREATE PROCEDURE GetPatientAppointments(IN inputPatientID INT)
BEGIN
    SELECT
        a.AppointmentID,
        p.FirstName,
        p.LastName,
        a.AppointmentDate,
        a.AppointmentTime,
        c.FirstName AS ClinicianFirstName,
        c.LastName AS ClinicianLastName
    FROM Appointment a
    INNER JOIN Patient p ON a.PatientID = p.PatientID
    INNER JOIN Clinician c ON a.ClinicianID = c.ClinicianID
    WHERE a.PatientID = inputPatientID;
END$$
DELIMITER ;

CALL GetPatientAppointments(1);

-- C6: BEFORE INSERT trigger - follow-up date must not precede appointment date.
-- NOTE: The report screenshot shows the resulting Error 1048, but does not
-- show the complete original trigger definition. The following reproduces
-- the behaviour described in the report (invalid DueDate becomes NULL).
DROP TRIGGER IF EXISTS CheckFollowUpDate;
DELIMITER $$
CREATE TRIGGER CheckFollowUpDate
BEFORE INSERT ON FollowUpPlan
FOR EACH ROW
BEGIN
    IF NEW.DueDate < (
        SELECT AppointmentDate
        FROM Appointment
        WHERE AppointmentID = NEW.AppointmentID
    ) THEN
        SET NEW.DueDate = NULL;
    END IF;
END$$
DELIMITER ;

-- C6 validation (optional): Execute ONLY when ready to test. It deliberately
-- causes MySQL Error 1048 (DueDate cannot be NULL) and should not be run
-- as part of routine database setup.
-- Ensure AppointmentID 11 and FollowUpID 11 are unused before running.
-- INSERT INTO Appointment
--     (AppointmentID, PatientID, ClinicianID, ClinicID, AppointmentDate, AppointmentTime)
-- VALUES (11, 1, 1, 1, '2026-11-15', '10:00:00');
-- INSERT INTO FollowUpPlan
--     (FollowUpID, AppointmentID, DueDate, Priority, Status, Notes)
-- VALUES (11, 11, '2026-11-10', 'Routine', 'Pending', 'Trigger test');
-- DELETE FROM Appointment WHERE AppointmentID = 11;
