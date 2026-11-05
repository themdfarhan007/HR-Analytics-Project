-- STEP 47: EMPLOYEE STATUS ANALYSIS
-- OBJECTIVE:
-- Classify employees as Current or Former
-- using 03-Nov-2026 as the reference date.
--
-- Blank termination dates and future termination
-- dates are classified as Current Employees.
-- Termination dates on or before the reference
-- date are classified as Former Employees.

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

    COUNT(*) AS employee_count

FROM HR

GROUP BY employee_status
ORDER BY employee_count DESC;

