-- STEP 46: PREPARE HR KPI SUMMARY
-- OBJECTIVE:
-- Calculate the three main HR performance indicators.
-- This dataset will be used to create KPI Cards in Power BI.

USE project_hr_analytics;

SELECT

    -- KPI 1: Total number of employees
    COUNT(*) AS total_employees,

    -- KPI 2: Headquarters employee count
    SUM(
        CASE
            WHEN location = 'Headquarters' THEN 1
            ELSE 0
        END
    ) AS headquarters_employees,

    -- KPI 3: Headquarters percentage
    ROUND(
        SUM(
            CASE
                WHEN location = 'Headquarters' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS headquarters_percentage,

    -- KPI 4: Remote employee count
    SUM(
        CASE
            WHEN location = 'Remote' THEN 1
            ELSE 0
        END
    ) AS remote_employees,

    -- KPI 5: Remote percentage
    ROUND(
        SUM(
            CASE
                WHEN location = 'Remote' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS remote_percentage,

    -- KPI 6: Average employee age
    ROUND(AVG(Age), 2) AS average_employee_age

FROM HR;