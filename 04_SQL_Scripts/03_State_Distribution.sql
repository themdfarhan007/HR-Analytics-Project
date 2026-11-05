-- STEP 43: EXPORT STATE DISTRIBUTION DATA
-- OBJECTIVE:
-- Calculate employee count and percentage by state.
-- This dataset will be used to create a Bar Chart in Power BI.

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