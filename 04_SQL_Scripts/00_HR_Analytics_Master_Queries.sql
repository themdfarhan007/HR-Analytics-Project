-- PROJECT: HR ANALYTICS


-- STEP 1: SELECT THE DATABASE
-- PURPOSE: Set the database for our project.

USE project_hr_analytics;

-- STEP 2: DISPLAY AVAILABLE TABLES
-- PURPOSE: Identify the tables available in our database.

SHOW TABLES;

-- STEP 3: INSPECT TABLE STRUCTURE
-- OBJECTIVE: Identify column names and their data types.

-- Display the structure of the HR table.
DESCRIBE HR;

-- STEP 4: VERIFY TOTAL RECORDS
-- OBJECTIVE: Count the number of records in the HR table.

SELECT COUNT(*) AS total_records
FROM HR;

-- STEP 5: PREVIEW EMPLOYEE DATA
-- OBJECTIVE: Inspect the first 10 records.

SELECT *
FROM HR
LIMIT 10;

-- STEP 6: CHECK FOR DUPLICATE EMPLOYEE IDS
-- OBJECTIVE: Identify IDs appearing more than once.

-- Group records by employee ID and identify duplicates.
-- HAVING filters groups that contain more than one record.

SELECT
    id,
    COUNT(*) AS occurrence_count
FROM HR
GROUP BY id
HAVING COUNT(*) > 1;

-- STEP 7: CHECK FOR MISSING AND BLANK VALUES
-- OBJECTIVE: Identify NULL values and empty text fields.
-- TABLE: HR

SELECT
    -- Check employee identification and personal information
    SUM(CASE
        WHEN id IS NULL OR TRIM(id) = '' THEN 1
        ELSE 0
    END) AS missing_id,

    SUM(CASE
        WHEN first_name IS NULL OR TRIM(first_name) = '' THEN 1
        ELSE 0
    END) AS missing_first_name,

    SUM(CASE
        WHEN last_name IS NULL OR TRIM(last_name) = '' THEN 1
        ELSE 0
    END) AS missing_last_name,

    SUM(CASE
        WHEN birthdate IS NULL OR TRIM(birthdate) = '' THEN 1
        ELSE 0
    END) AS missing_birthdate,

    SUM(CASE
        WHEN Age IS NULL THEN 1
        ELSE 0
    END) AS missing_age,

    -- Check demographic information
    SUM(CASE
        WHEN gender IS NULL OR TRIM(gender) = '' THEN 1
        ELSE 0
    END) AS missing_gender,

    SUM(CASE
        WHEN race IS NULL OR TRIM(race) = '' THEN 1
        ELSE 0
    END) AS missing_race,

    -- Check employment information
    SUM(CASE
        WHEN department IS NULL OR TRIM(department) = '' THEN 1
        ELSE 0
    END) AS missing_department,

    SUM(CASE
        WHEN jobtitle IS NULL OR TRIM(jobtitle) = '' THEN 1
        ELSE 0
    END) AS missing_jobtitle,

    SUM(CASE
        WHEN location IS NULL OR TRIM(location) = '' THEN 1
        ELSE 0
    END) AS missing_location,

    SUM(CASE
        WHEN hire_date IS NULL OR TRIM(hire_date) = '' THEN 1
        ELSE 0
    END) AS missing_hire_date,

    -- Check geographic information
    SUM(CASE
        WHEN location_city IS NULL OR TRIM(location_city) = '' THEN 1
        ELSE 0
    END) AS missing_city,

    SUM(CASE
        WHEN location_state IS NULL OR TRIM(location_state) = '' THEN 1
        ELSE 0
    END) AS missing_state
    
FROM HR;

-- STEP 8: VALIDATE EMPLOYEE AGES
-- OBJECTIVE: Examine the minimum, maximum, and average age.

SELECT
    MIN(Age) AS minimum_age,
    MAX(Age) AS maximum_age,
    ROUND(AVG(Age), 2) AS average_age
FROM HR;

-- STEP 9A: INSPECT BIRTHDATE VALUES
-- OBJECTIVE: Understand the stored birthdate format.
-- Display 10 birthdate values for inspection.

SELECT birthdate
FROM HR
LIMIT 10;

-- STEP 9B: INSPECT HIRE DATE VALUES
-- OBJECTIVE: Understand the stored hiring date format.
-- Display 10 hire_date values for inspection.

SELECT hire_date
FROM HR
LIMIT 10;

-- STEP 10: VALIDATE HIRING DATES
-- OBJECTIVE: Check whether hiring dates can be converted into valid dates.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN STR_TO_DATE(hire_date, '%d-%m-%Y') IS NULL
            THEN 1
            ELSE 0
        END
    ) AS invalid_hire_dates,

    MIN(STR_TO_DATE(hire_date, '%d-%m-%Y')) AS earliest_hire_date,

    MAX(STR_TO_DATE(hire_date, '%d-%m-%Y')) AS latest_hire_date

FROM HR;


-- STEP 11: VALIDATE BIRTHDATES
-- OBJECTIVE: Check for invalid birthdates and identify
-- the earliest and latest birthdates in the dataset.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN STR_TO_DATE(birthdate, '%d-%m-%Y') IS NULL
            THEN 1
            ELSE 0
        END
    ) AS invalid_birthdates,

    MIN(STR_TO_DATE(birthdate, '%d-%m-%Y')) AS earliest_birthdate,

    MAX(STR_TO_DATE(birthdate, '%d-%m-%Y')) AS latest_birthdate

FROM HR;


-- STEP 12: INSPECT TERMINATION DATES
-- OBJECTIVE: Examine termination-date values before validating them.

USE project_hr_analytics;

SELECT termdate
FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
LIMIT 10;


-- STEP 13: VALIDATE TERMINATION DATES
-- OBJECTIVE: Check whether termination dates can be converted
-- into valid datetime values and identify their date range.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN termdate IS NOT NULL
                 AND TRIM(termdate) <> ''
            THEN 1
            ELSE 0
        END
    ) AS nonblank_term_dates,

    SUM(
        CASE
            WHEN termdate IS NOT NULL
                 AND TRIM(termdate) <> ''
                 AND STR_TO_DATE(
                     REPLACE(termdate, ' UTC', ''),
                     '%Y-%m-%d %H:%i:%s'
                 ) IS NULL
            THEN 1
            ELSE 0
        END
    ) AS invalid_term_dates,

    MIN(
        STR_TO_DATE(
            REPLACE(termdate, ' UTC', ''),
            '%Y-%m-%d %H:%i:%s'
        )
    ) AS earliest_term_date,

    MAX(
        STR_TO_DATE(
            REPLACE(termdate, ' UTC', ''),
            '%Y-%m-%d %H:%i:%s'
        )
    ) AS latest_term_date

FROM HR;


-- STEP 14: INVESTIGATE FUTURE TERMINATION DATES
-- OBJECTIVE: Count termination dates occurring after the
-- reference date and display sample records for investigation.

USE project_hr_analytics;

-- Part A: Count future termination dates.
SELECT
    COUNT(*) AS future_termination_records
FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) > '2026-11-03 23:59:59';

-- Part B: Display 10 sample records with future termination dates.
SELECT
    id,
    first_name,
    last_name,
    department,
    hire_date,
    termdate
FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) > '2026-11-03 23:59:59'
ORDER BY STR_TO_DATE(
    REPLACE(termdate, ' UTC', ''),
    '%Y-%m-%d %H:%i:%s'
)
LIMIT 10;


-- STEP 15: CHECK EMPLOYEE LOCATION CATEGORIES
-- OBJECTIVE: Identify the location categories and count
-- employees in each category.

USE project_hr_analytics;

SELECT
    location,
    COUNT(*) AS employee_count
FROM HR
GROUP BY location
ORDER BY employee_count DESC;


-- STEP 16: ANALYZE GENDER DISTRIBUTION
-- OBJECTIVE: Identify gender categories and count employees
-- in each category for the gender distribution chart.

USE project_hr_analytics;

SELECT
    gender,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY gender
ORDER BY employee_count DESC;


-- STEP 17: ANALYZE EMPLOYEE DISTRIBUTION BY DEPARTMENT
-- OBJECTIVE: Count employees in each department and calculate
-- each department's percentage of the total dataset.

USE project_hr_analytics;

SELECT
    department,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY department
ORDER BY employee_count DESC;


-- STEP 18: ANALYZE EMPLOYEE DISTRIBUTION BY STATE
-- OBJECTIVE: Count records in each state and calculate
-- each state's percentage of the total dataset.

USE project_hr_analytics;

SELECT
    location_state,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY location_state
ORDER BY employee_count DESC;


-- STEP 19: ANALYZE EMPLOYEE DISTRIBUTION BY RACE
-- OBJECTIVE: Count records in each race category and calculate
-- each category's percentage of the total dataset.

USE project_hr_analytics;

SELECT
    race,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY race
ORDER BY employee_count DESC;


-- STEP 20: ANALYZE HIRING TRENDS BY YEAR
-- OBJECTIVE: Count employee records by hiring year.
-- The hire_date column is stored as DD-MM-YYYY text.

USE project_hr_analytics;

SELECT
    YEAR(
        STR_TO_DATE(hire_date, '%d-%m-%Y')
    ) AS hiring_year,

    COUNT(*) AS employees_hired

FROM HR

GROUP BY YEAR(
    STR_TO_DATE(hire_date, '%d-%m-%Y')
)

ORDER BY hiring_year;


-- STEP 21: CLASSIFY CURRENT AND FORMER EMPLOYEES
-- OBJECTIVE: Calculate employee counts based on termination dates.
-- REFERENCE DATE: 3 November 2026
-- ASSUMPTION:
-- 1. Blank termination dates indicate current employees.
-- 2. Future termination dates indicate current employees as of the reference date.
-- 3. Termination dates on or before the reference date indicate former employees.

USE project_hr_analytics;

SELECT
    CASE
        WHEN termdate IS NULL
             OR TRIM(termdate) = ''
             OR STR_TO_DATE(
                 REPLACE(termdate, ' UTC', ''),
                 '%Y-%m-%d %H:%i:%s'
             ) > '2026-11-03 23:59:59'
        THEN 'Current Employee'
        ELSE 'Former Employee'
    END AS employee_status,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage

FROM HR

GROUP BY employee_status
ORDER BY employee_count DESC;


-- STEP 22: CALCULATE EMPLOYEE AGE KPI
-- OBJECTIVE: Calculate the average, minimum, and maximum
-- ages recorded in the HR dataset.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,
    ROUND(AVG(Age), 2) AS average_employee_age,
    MIN(Age) AS minimum_employee_age,
    MAX(Age) AS maximum_employee_age
FROM HR;


-- STEP 23: CALCULATE THE THREE MAIN HR KPIs
-- OBJECTIVE:
-- 1. Calculate total employee records.
-- 2. Calculate Headquarters and Remote workforce percentages.
-- 3. Calculate the average employee age.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_employee_records,

    SUM(CASE
        WHEN location = 'Headquarters' THEN 1
        ELSE 0
    END) AS headquarters_employees,

    ROUND(
        SUM(CASE
            WHEN location = 'Headquarters' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*), 2
    ) AS headquarters_percentage,

    SUM(CASE
        WHEN location = 'Remote' THEN 1
        ELSE 0
    END) AS remote_employees,

    ROUND(
        SUM(CASE
            WHEN location = 'Remote' THEN 1
            ELSE 0
        END) * 100.0 / COUNT(*), 2
    ) AS remote_percentage,

    ROUND(AVG(Age), 2) AS average_employee_age

FROM HR;


-- STEP 24: VALIDATE EMPLOYEE AGE AGAINST BIRTHDATE
-- OBJECTIVE:
-- Compare the recorded Age with the age calculated
-- from birthdate as of 3 November 2026.
-- Birthdates are stored in DD-MM-YYYY format.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN Age =
                TIMESTAMPDIFF(
                    YEAR,
                    STR_TO_DATE(birthdate, '%d-%m-%Y'),
                    '2026-11-03'
                )
            THEN 1
            ELSE 0
        END
    ) AS matching_age_records,

    SUM(
        CASE
            WHEN Age <>
                TIMESTAMPDIFF(
                    YEAR,
                    STR_TO_DATE(birthdate, '%d-%m-%Y'),
                    '2026-11-03'
                )
            THEN 1
            ELSE 0
        END
    ) AS mismatching_age_records

FROM HR
WHERE STR_TO_DATE(birthdate, '%d-%m-%Y') IS NOT NULL;


-- STEP 25: INVESTIGATE AGE MISMATCHES
-- OBJECTIVE:
-- Compare recorded ages with ages calculated from birthdates.
-- Use a sample of 10 employee records for investigation.
-- Reference date: 3 November 2026.
-- This query only reads data; it does not modify any records.

USE project_hr_analytics;

SELECT
    id,
    birthdate,
    Age AS recorded_age,

    TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(birthdate, '%d-%m-%Y'),
        '2026-11-03'
    ) AS calculated_age,

    Age - TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(birthdate, '%d-%m-%Y'),
        '2026-11-03'
    ) AS age_difference

FROM HR
WHERE STR_TO_DATE(birthdate, '%d-%m-%Y') IS NOT NULL
ORDER BY id
LIMIT 10;


-- STEP 26: TEST AGE CONSISTENCY ACROSS REFERENCE YEARS
-- OBJECTIVE:
-- Determine whether the recorded Age values match ages
-- calculated at the end of 2022, 2023, or 2026.
-- This query only reads data and does not modify records.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    SUM(
        CASE
            WHEN Age = TIMESTAMPDIFF(
                YEAR,
                STR_TO_DATE(birthdate, '%d-%m-%Y'),
                '2022-12-31'
            )
            THEN 1 ELSE 0
        END
    ) AS matches_2022,

    SUM(
        CASE
            WHEN Age = TIMESTAMPDIFF(
                YEAR,
                STR_TO_DATE(birthdate, '%d-%m-%Y'),
                '2023-12-31'
            )
            THEN 1 ELSE 0
        END
    ) AS matches_2023,

    SUM(
        CASE
            WHEN Age = TIMESTAMPDIFF(
                YEAR,
                STR_TO_DATE(birthdate, '%d-%m-%Y'),
                '2026-11-03'
            )
            THEN 1 ELSE 0
        END
    ) AS matches_2026

FROM HR
WHERE STR_TO_DATE(birthdate, '%d-%m-%Y') IS NOT NULL;

-- STEP 27: CALCULATE AGE DIRECTLY FROM BIRTHDATES
-- OBJECTIVE:
-- Calculate average, minimum, and maximum ages using
-- birthdates as of 3 November 2026.
-- The original Age column remains unchanged.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_records,

    ROUND(
        AVG(
            TIMESTAMPDIFF(
                YEAR,
                STR_TO_DATE(birthdate, '%d-%m-%Y'),
                '2026-11-03'
            )
        ),
        2
    ) AS average_calculated_age,

    MIN(
        TIMESTAMPDIFF(
            YEAR,
            STR_TO_DATE(birthdate, '%d-%m-%Y'),
            '2026-11-03'
        )
    ) AS minimum_calculated_age,

    MAX(
        TIMESTAMPDIFF(
            YEAR,
            STR_TO_DATE(birthdate, '%d-%m-%Y'),
            '2026-11-03'
        )
    ) AS maximum_calculated_age

FROM HR
WHERE STR_TO_DATE(birthdate, '%d-%m-%Y') IS NOT NULL;

-- STEP 28: ANALYZE AGE DIFFERENCES
-- OBJECTIVE:
-- Count employees by the difference between their
-- original recorded age and calculated age.
-- Reference date: 3 November 2026.
-- This query does not modify the original data.

USE project_hr_analytics;

SELECT
    TIMESTAMPDIFF(
        YEAR,
        STR_TO_DATE(birthdate, '%d-%m-%Y'),
        '2026-11-03'
    ) - Age AS age_difference,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage

FROM HR
WHERE STR_TO_DATE(birthdate, '%d-%m-%Y') IS NOT NULL

GROUP BY age_difference
ORDER BY age_difference;

-- STEP 29: VALIDATE HIRE AND TERMINATION DATES
-- OBJECTIVE:
-- Identify records where the termination date occurs
-- before the hire date.
-- Hire dates use DD-MM-YYYY format.
-- Termination dates use YYYY-MM-DD HH:MM:SS UTC.
-- This query does not modify any records.

USE project_hr_analytics;

SELECT
    COUNT(*) AS records_with_both_dates,

    SUM(
        CASE
            WHEN STR_TO_DATE(
                REPLACE(termdate, ' UTC', ''),
                '%Y-%m-%d %H:%i:%s'
            ) <
            STR_TO_DATE(hire_date, '%d-%m-%Y')
            THEN 1
            ELSE 0
        END
    ) AS termination_before_hire,

    SUM(
        CASE
            WHEN STR_TO_DATE(
                REPLACE(termdate, ' UTC', ''),
                '%Y-%m-%d %H:%i:%s'
            ) >=
            STR_TO_DATE(hire_date, '%d-%m-%Y')
            THEN 1
            ELSE 0
        END
    ) AS termination_on_or_after_hire

FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
  AND STR_TO_DATE(hire_date, '%d-%m-%Y') IS NOT NULL
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) IS NOT NULL;
  
-- STEP 30: ANALYZE EMPLOYEE DISTRIBUTION BY DEPARTMENT
-- OBJECTIVE:
-- Calculate the number and percentage of employees
-- belonging to each department.

USE project_hr_analytics;

SELECT
    department,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS employee_percentage

FROM HR

GROUP BY department

ORDER BY employee_count DESC;

-- STEP 31: ANALYZE EMPLOYEE DISTRIBUTION BY JOB TITLE
-- OBJECTIVE:
-- Calculate the number and percentage of employees
-- working under each job title.

USE project_hr_analytics;

SELECT
    jobtitle,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS employee_percentage

FROM HR

GROUP BY jobtitle

ORDER BY employee_count DESC;

-- STEP 32: COUNT UNIQUE JOB TITLES AND DEPARTMENTS
-- OBJECTIVE:
-- Calculate the total employee records,
-- unique job titles, and unique departments.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_employee_records,

    COUNT(DISTINCT jobtitle) AS unique_job_titles,

    COUNT(DISTINCT department) AS unique_departments

FROM HR;

-- STEP 33: ANALYZE EMPLOYEE DISTRIBUTION BY CITY
-- OBJECTIVE:
-- Calculate employee count and percentage
-- for each city.

USE project_hr_analytics;

SELECT
    location_city,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS employee_percentage

FROM HR

GROUP BY location_city

ORDER BY employee_count DESC;

-- STEP 34: INVESTIGATE CLEVELAND WORK LOCATION
-- OBJECTIVE:
-- Identify the distribution of Cleveland employees
-- between Headquarters and Remote categories.
-- This query does not modify any records.

USE project_hr_analytics;

SELECT
    location,

    COUNT(*) AS employee_count,

    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*)
         FROM HR
         WHERE location_city = 'Cleveland'),
        2
    ) AS percentage

FROM HR

WHERE location_city = 'Cleveland'

GROUP BY location

ORDER BY employee_count DESC;

-- STEP 35: CHECK CITIES ASSOCIATED WITH MULTIPLE STATES
-- OBJECTIVE:
-- Identify city names that are recorded under more than one state.
-- This is a data validation check; no records will be modified.

USE project_hr_analytics;

SELECT
    location_city,
    COUNT(DISTINCT location_state) AS number_of_states,
    GROUP_CONCAT(
        DISTINCT location_state
        ORDER BY location_state
    ) AS associated_states,
    COUNT(*) AS employee_count
FROM HR
GROUP BY location_city
HAVING COUNT(DISTINCT location_state) > 1
ORDER BY number_of_states DESC, employee_count DESC;

-- STEP 36: PREPARE GENDER DISTRIBUTION DATA
-- OBJECTIVE:
-- Calculate employee count and percentage by gender.
-- This result will be used to create a Donut Chart in Power BI.

USE project_hr_analytics;

SELECT
    gender,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY gender
ORDER BY employee_count DESC;

-- STEP 37: PREPARE EMPLOYEE DISTRIBUTION BY STATE
-- OBJECTIVE:
-- Calculate the number and percentage of employees in each state.
-- This result will be used to create a Bar Chart in Power BI.

USE project_hr_analytics;

SELECT
    location_state,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY location_state
ORDER BY employee_count DESC;

-- STEP 38: PREPARE EMPLOYEE DISTRIBUTION BY DEPARTMENT
-- OBJECTIVE:
-- Calculate the number and percentage of employees in each department.
-- This result will be used to create a Bar Chart in Power BI.

USE project_hr_analytics;

SELECT
    department,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY department
ORDER BY employee_count DESC;

-- STEP 39: PREPARE EMPLOYEE DISTRIBUTION BY RACE
-- OBJECTIVE:
-- Calculate the number and percentage of employees in each race category.
-- This result will be used to create a Bar Chart in Power BI.

USE project_hr_analytics;

SELECT
    race,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY race
ORDER BY employee_count DESC;

-- STEP 40: PREPARE YEAR-WISE HIRING TREND DATA
-- OBJECTIVE:
-- Calculate the number of employees hired in each year.
-- This result will be used to create a Line Chart in Power BI.

USE project_hr_analytics;

SELECT
    YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y')) AS hiring_year,
    COUNT(*) AS employees_hired
FROM HR
WHERE STR_TO_DATE(hire_date, '%d-%m-%Y') IS NOT NULL
GROUP BY YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y'))
ORDER BY hiring_year;