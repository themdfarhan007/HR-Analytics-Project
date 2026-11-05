-- STEP 41: EXPORT HIRING TREND DATA
-- OBJECTIVE:
-- Retrieve the annual employee hiring counts.
-- The result will be exported as a CSV file for Power BI.

USE project_hr_analytics;

SELECT
    YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y')) AS hiring_year,
    COUNT(*) AS employees_hired
FROM HR
WHERE STR_TO_DATE(hire_date, '%d-%m-%Y') IS NOT NULL
GROUP BY YEAR(STR_TO_DATE(hire_date, '%d-%m-%Y'))
ORDER BY hiring_year;