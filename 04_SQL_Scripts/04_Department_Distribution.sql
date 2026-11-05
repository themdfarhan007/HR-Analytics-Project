-- STEP 44: EXPORT DEPARTMENT DISTRIBUTION DATA
-- OBJECTIVE:
-- Calculate employee count and percentage by department.
-- This dataset will be used to create a Bar Chart in Power BI.

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