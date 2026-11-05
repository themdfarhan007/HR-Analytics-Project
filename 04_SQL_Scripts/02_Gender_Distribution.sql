-- STEP 42: EXPORT GENDER DISTRIBUTION DATA
-- OBJECTIVE:
-- Retrieve employee counts and percentages by gender.
-- The result will be used for the Gender Donut Chart in Power BI.

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