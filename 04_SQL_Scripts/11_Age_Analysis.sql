-- PROJECT: HR ANALYTICS
-- FILE: 11_Age_Analysis.sql

USE project_hr_analytics;


-- QUERY 1: EMPLOYEE DISTRIBUTION BY AGE
-- Objective: Count employees at each recorded age.

SELECT
    Age,
    COUNT(*) AS total_employees
FROM HR
WHERE Age IS NOT NULL
GROUP BY Age
ORDER BY Age;


-- QUERY 2: EMPLOYEE DISTRIBUTION BY AGE GROUP
-- Objective: Categorise employees into age groups
-- and calculate their percentage of total records.

SELECT
    CASE
        WHEN Age BETWEEN 18 AND 25 THEN '18-25'
        WHEN Age BETWEEN 26 AND 35 THEN '26-35'
        WHEN Age BETWEEN 36 AND 45 THEN '36-45'
        WHEN Age BETWEEN 46 AND 55 THEN '46-55'
        WHEN Age >= 56 THEN '56+'
        ELSE 'Outside Defined Range'
    END AS age_group,

    COUNT(*) AS total_employees,

    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS employee_percentage

FROM HR
WHERE Age IS NOT NULL
GROUP BY age_group
ORDER BY MIN(Age);