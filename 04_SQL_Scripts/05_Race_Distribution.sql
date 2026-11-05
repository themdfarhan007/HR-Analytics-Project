-- STEP 45: EXPORT RACE DISTRIBUTION DATA
-- OBJECTIVE:
-- Calculate employee count and percentage by race.
-- This dataset will be used to create a Bar Chart in Power BI.

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