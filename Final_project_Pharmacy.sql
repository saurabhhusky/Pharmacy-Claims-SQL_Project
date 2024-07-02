use final_project_pharmacy;

#creating dimension and fact tables
CREATE TABLE member_dim (
    member_id INT PRIMARY KEY,
    member_first_name VARCHAR(50),
    member_last_name VARCHAR(50),
    member_birth_date DATE,
    member_age INT,
    member_gender CHAR(1)
);
CREATE TABLE drug_dim (
    drug_ndc INT PRIMARY KEY,
    drug_name VARCHAR(100)
);
CREATE TABLE drug_form_dim (
    drug_form_code CHAR(2) PRIMARY KEY,
    drug_form_desc VARCHAR(100),
    drug_brand_generic_code INT
);
CREATE TABLE fact_table (
    Fact_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    drug_ndc INT,
    fill_date DATE,
    copay INT,
    insurance_paid INT,
    FOREIGN KEY (member_id) REFERENCES member_dim(member_id) ON DELETE SET NULL ON UPDATE SET NULL,
    FOREIGN KEY (drug_ndc) REFERENCES drug_dim(drug_ndc) ON DELETE SET NULL ON UPDATE SET NULL
);

#inserting values into the tables
INSERT INTO member_dim (member_id, member_first_name, member_last_name, member_birth_date, member_age, member_gender)
VALUES 
(10001, 'David', 'Dennison', '1946-06-14', 72, 'M'),
(10002, 'John', 'Smith', '1962-01-02', 56, 'M'),
(10003, 'Jane', 'Doe', '1982-05-04', 36, 'F'),
(10004, 'Elaine', 'Rogers', '1983-10-12', 34, 'F');
SET SQL_SAFE_UPDATES = 0;


INSERT INTO drug_dim (drug_ndc, drug_name)
VALUES 
(433530848, 'Risperidone'),
(545695193, 'Amoxicillin'),
(545693828, 'Ambien'),
(185085302, 'Diprosone');
SET SQL_SAFE_UPDATES = 0;

INSERT INTO drug_form_dim (drug_form_code, drug_form_desc, drug_brand_generic_code)
VALUES 
('TB', 'Tablet', 1),
('OS', 'Oral Solution', 1),
('TB', 'Tablet', 2),
('TC', 'Topical Cream', 1)
ON DUPLICATE KEY UPDATE drug_form_code = drug_form_code; -- This line prevents the duplicate entry error
SET SQL_SAFE_UPDATES = 0;

INSERT INTO fact_table (member_id, drug_ndc, fill_date, copay, insurance_paid)
VALUES 
(10001, 433530848, '2017-10-31', 15, 50),
(10001, 545693828, '2018-01-15', 20, 650),
(10002, 545695193, '2018-06-14', 50, 130),
(10003, 545693828, '2017-12-30', 35, 250),
(10004, 185085302, '2017-11-09', 15, 600),
(10001, 433530848, '2018-02-22', 15, 48),
(10001, 433530848, '2018-05-08', 15, 55),
(10003, 545693828, '2018-05-16', 35, 322),
(10004, 185085302, '2017-12-08', 15, 712);

SET SQL_SAFE_UPDATES = 0;

#view tables
select * from fact_table;
select * from drug_form_dim;
select * from drug_dim;
select * from member_dim;

#1. A SQL query that identifies the number of prescriptions grouped by drug name. 
SELECT drug_dim.drug_name, COUNT(fact_table.drug_ndc) AS prescription_count
FROM fact_table
JOIN drug_dim ON fact_table.drug_ndc = drug_dim.drug_ndc
GROUP BY drug_dim.drug_name;

#1.a How many prescriptions were filled for the drug Ambien?
SELECT COUNT(*) AS ambien_prescriptions
FROM fact_table
LEFT JOIN drug_dim ON fact_table.drug_ndc = drug_dim.drug_ndc
WHERE drug_dim.drug_name = 'Ambien';

#2. A SQL query that counts total prescriptions, counts unique (i.e. distinct) members, sums copay
# and suminsurancepaid, for members grouped as either ‘age 65+’ or ’ < 65’.
SELECT
    CASE
        WHEN member_age >= 65 THEN 'age 65+'
        ELSE '< 65'
    END AS age_group,
    COUNT(*) AS total_prescriptions,
    COUNT(DISTINCT fact_table.member_id) AS unique_members,
    SUM(copay) AS total_copay,
    SUM(insurance_paid) AS total_insurance_paid
FROM
    fact_table
LEFT JOIN
    member_dim ON fact_table.member_id = member_dim.member_id
GROUP BY
    age_group;

#2.a How many unique members are over 65 years of age? 
#How many prescriptions did they fill?
SELECT
    COUNT(DISTINCT member_dim.member_id) AS unique_members_over_65,
    COUNT(*) AS total_prescriptions_over_65
FROM
    fact_table
JOIN
    member_dim ON fact_table.member_id = member_dim.member_id
WHERE
    member_age >= 65;
    

#3. a SQL query that identifies the amount paid by the insurance for the most recent prescription fill date. Use the format that we learned with SQL Window functions.
WITH RankedPrescriptions AS (
    SELECT
        member_dim.member_id,
        member_dim.member_first_name,
        member_dim.member_last_name,
        drug_dim.drug_name,
        fact_table.fill_date,
        fact_table.insurance_paid,
        ROW_NUMBER() OVER (PARTITION BY member_dim.member_id ORDER BY fact_table.fill_date DESC) AS rn
    FROM
        fact_table
    LEFT JOIN
        member_dim ON fact_table.member_id = member_dim.member_id
    LEFT JOIN
        drug_dim ON fact_table.drug_ndc = drug_dim.drug_ndc
)
SELECT
    member_id,
    member_first_name,
    member_last_name,
    drug_name,
    fill_date,
    insurance_paid
FROM
    RankedPrescriptions
WHERE
    rn = 1;

#4. For member ID 10003, what was the drug name listed on their most recent fill date?
#How much did their insurance pay for that medication?
SELECT
    member_dim.member_id,
    member_dim.member_first_name,
    member_dim.member_last_name,
    drug_dim.drug_name AS recent_drug_name,
    fact_table.fill_date,
    fact_table.insurance_paid AS insurance_paid_for_recent_medication
FROM
    fact_table
LEFT JOIN
    member_dim ON fact_table.member_id = member_dim.member_id
LEFT JOIN
    drug_dim ON fact_table.drug_ndc = drug_dim.drug_ndc
WHERE
    fact_table.member_id = 10003
ORDER BY
    fact_table.fill_date DESC
LIMIT 1;



