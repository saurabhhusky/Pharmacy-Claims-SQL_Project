# Project Title
Pharmacy Claims in SQL


# Project Overview
The project involved normalizing and analyzing a dataset of pharmacy claims processed by a fictitious insurance company. The initial dataset was not in the first normal form (1NF) and included repetitive fields and partial dependencies, which complicated data handling and analysis. The main objectives were to:

Normalize the dataset to adhere to the first, second, and third normal forms (1NF, 2NF, 3NF).
Establish a clear entity-relationship model using primary and foreign keys to ensure data integrity.
Facilitate efficient data querying and generate insightful reports on prescription patterns and costs.
The normalization process involved creating separate dimension tables (member_dim, drug_dim, drug_form_dim) and a fact table (fact_table). 
Primary keys were defined for each table, and foreign key constraints were set up in the fact_table to reference the dimension tables, with rules to handle deletions and updates by setting the foreign keys to NULL to preserve historical data.

# Key Insights

Improved Data Integrity and Efficiency:
The normalization process eliminated data redundancy and ensured that the dataset adhered to the 3NF, making it more manageable and efficient for querying and analysis.

Clear Entity-Relationship Model:
The creation of a star schema with one fact table and three dimension tables improved the clarity and structure of the data, facilitating more straightforward and accurate data analysis.

Enhanced Query Performance:
Normalizing the data and establishing primary and foreign key relationships significantly improved the performance and accuracy of queries. This enhancement is crucial for generating timely and reliable reports.

Valuable Healthcare Insights:
Analysis revealed specific trends and patterns, such as:
A total of three Ambien prescriptions were identified.
Members aged 65 and above filled four prescriptions.
Member ID 10003 filled the most recent prescription for Ambien on May 16, 2018, with an insurance payout of $322 for the drug.

Effective Historical Data Management:
By setting foreign keys to NULL upon deletion or update, the project ensured that historical data remains intact and unaltered, supporting long-term data analysis and reporting.
The successful normalization and analysis of the pharmacy claims dataset provide a robust foundation for informed decision-making in healthcare, highlighting the importance of proper data structuring and management.

# Key Analysis

Normalization and Data Structuring:
1NF Implementation: The initial dataset did not comply with 1NF due to repetitive fields such as multiple "date filled" and "copay" attributes. The first step involved restructuring these fields to ensure each column contained atomic values, eliminating any repeating groups.
2NF Implementation: After achieving 1NF, the dataset still faced issues with partial dependencies. To resolve this, the data was split into three tables, separating member information, drug details, and the facts related to prescriptions.
3NF Implementation: The final step involved removing transitive dependencies by further dividing the drug_ndc_dim table into drug_dim and drug_form_dim. This ensured that all non-key attributes were fully functionally dependent on the primary key, resulting in a more efficient and streamlined database structure.

Entity-Relationship Modeling:
Primary Keys: Each table was assigned a primary key to uniquely identify records. For instance, member_id for member_dim, drug_ndc for drug_dim, and drug_form_code for drug_form_dim.
Foreign Keys: The fact_table included foreign keys referencing the dimension tables (member_dim and drug_dim). This setup ensured referential integrity, with rules to set these foreign keys to NULL upon deletion or update to maintain historical data accuracy.

Query Performance and Data Retrieval:
Ambien Prescriptions: Analysis of the dataset showed that there were three prescriptions for Ambien, allowing the insurance company to track the usage and costs associated with this medication.

Age-Based Analysis: Queries focusing on members aged 65 and above revealed that these members filled a total of four prescriptions. This insight can help in understanding the prescription needs and costs associated with senior members.

Member-Specific Analysis: For member ID 10003, the most recent prescription was filled on May 16, 2018, for Ambien, with an insurance payout of $322. This specific information aids in tracking individual member’s medication history and costs.

Historical Data Management:
NULL Handling for Foreign Keys: By setting foreign keys to NULL on deletion or update, the analysis preserved the integrity of historical data. This approach is crucial for maintaining accurate records over time, allowing for comprehensive longitudinal studies and reporting.

Analytical Queries and Reporting:
The normalized data structure enabled efficient execution of complex queries, providing detailed and accurate reports. These reports can be used for various purposes, including cost analysis, medication usage tracking, and member behavior insights.

# Summary
The key analysis highlights the transformation of the pharmacy claims dataset from a non-normalized form to a robust, normalized structure adhering to 3NF. This process improved data integrity, query performance, and the ability to generate valuable insights. The structured approach to normalization and entity-relationship modeling enabled efficient data retrieval and analysis, facilitating informed decision-making in healthcare.

# Tools
MYSQL workbench
