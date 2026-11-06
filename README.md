# Crownfield Eye Hospital Database

## Project overview

This repository contains the MySQL database coursework for the Crownfield Eye Hospital scenario. The database organises patient, clinician, specialty, clinic, appointment, prescription, medicine and follow-up information. The work covers relational database design, normalisation, implementation, SQL queries, validation and data protection.

## Repository contents

The intended repository structure is:

```text
Crownfield-Eye-Hospital-Database/
├── 01_schema.sql
├── 02_individual_queries.sql
├── 03_procedure_and_trigger.sql
├── 04_security.sql
├── 05_ERD/
└── README.md
```

- **01_schema.sql** — Creates the database tables, relationships and constraints, and loads sample records where included.
- **02_individual_queries.sql** — Part C queries C1–C4: aggregate query, INNER JOIN, LEFT JOIN and subquery.
- **03_procedure_and_trigger.sql** — Part C operations C5–C6: `GetPatientAppointments` stored procedure and `CheckFollowUpDate` trigger.
- **04_security.sql** — Part D security work, including hashing demonstrations and role-based access controls where implemented.
- **05_ERD/** — Original entity-relationship diagram file(s).
- **README.md** — Setup, execution order and assumptions.

**Note:** This is the required *target structure*. Confirm that each named file has been added and tested before submitting the repository. The original Part C work was also assembled in `Part_C_Individual_SQL.sql`; if you retain that combined file, do not run it in addition to both split Part C files because procedures and triggers would be created again.

## Software requirements

- MySQL Server with permission to create tables, procedures, triggers and users/roles as needed.
- MySQL Workbench or another MySQL-compatible SQL client.
- GitHub account for hosting the individual repository.

## Setup and execution order

1. Open MySQL Workbench and connect to the intended MySQL server.
2. Open **`01_schema.sql`**. Run it to create the schema and populate any required sample data. Check the schema name used in this file; the Part C script currently uses `CrownfieldEyeHospital`.
3. Verify that the tables and their sample records exist before continuing. In particular, the Part C work relies on `Patient`, `Clinician`, `Specialty`, `Appointment`, `Prescription`, `Prescription_Item`, `Medicine` and `FollowUpPlan`.
4. Run **`02_individual_queries.sql`** to execute the four retrieval queries (C1–C4). Review their result sets.
5. Run **`03_procedure_and_trigger.sql`** to create the stored procedure and trigger (C5–C6). Test the procedure using `CALL GetPatientAppointments(1);` where patient ID 1 exists.
6. Run **`04_security.sql`** only after reviewing its user/role creation statements and permissions. Use a MySQL account with suitable administrative privileges where necessary.
7. Review **`05_ERD/`** and compare the diagram with the implemented table relationships.

**Important:** Run scripts in the order above. If the actual schema file creates a differently named database, update the `USE` statements in subsequent scripts to match it.

## Part C: individual SQL and validation

| Section | Operation | Purpose |
|---|---|---|
| C1 | `GROUP BY` / `HAVING` | Count appointments assigned to each clinician. |
| C2 | `INNER JOIN` | Retrieve prescription details alongside patient and clinician information. |
| C3 | `LEFT JOIN` | Identify patients without recorded appointments. |
| C4 | Subquery with `MAX()` | Retrieve appointments on the latest date in the sample data. |
| C5 | Stored procedure | Retrieve appointments for a specified patient ID. |
| C6 | Trigger | Prevent a follow-up due date earlier than its appointment date. |

The report describes a C6 negative test in which an invalid follow-up date was rejected with MySQL Error 1048 (`DueDate` cannot be `NULL`). This is a deliberate validation failure, **not** a successful insert. Do not run deliberate failure tests during routine setup. The trigger definition in the reconstructed Part C SQL should be checked against the final implemented version before submission.

## Part D: data protection and access control

The individual report demonstrates SHA-256 hashing using fictional input values and discusses separate permissions for Administrator, Doctor, Receptionist and Patient roles. The final `04_security.sql` should be reviewed to confirm which roles, grants and tests are actually implemented. A SHA-256 demonstration is not a recommended production password-storage solution; a dedicated password-hashing algorithm such as Argon2id is preferable.

## Assumptions and limitations

- The data used for coursework testing is **synthetic**, not real patient information.
- The queries assume the tables, column names and relationships defined in the final schema file.
- Some Part C outputs depend on the inserted sample data and may differ if records change.
- C3 can correctly return zero rows when all patients have appointments.
- The C6 negative test intentionally produces a database error when an invalid date is inserted.
- The report notes that a clearer trigger error could be implemented with MySQL `SIGNAL` instead of relying on a `NOT NULL` constraint error.
- Role permissions should be tested independently and must not be assumed to be complete merely because roles have been created.

## Submission checklist

- [ ] Individual DOCX report submitted to Moodle.
- [ ] ER diagram included in the report and original ERD file uploaded to GitHub.
- [ ] Individual GitHub repository contains the ordered SQL files and this README.
- [ ] SQL files run in the documented order against the final schema.
- [ ] Individual presentation slides (PPTX or PDF) submitted to Moodle.
- [ ] Individual recording (MP4) submitted as required.

## Academic context

Prepared for the Crownfield Eye Hospital database coursework. The individual report contains explanations and screenshots of the implementation and validation work.
