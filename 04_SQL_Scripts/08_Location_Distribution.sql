-- STEP 48: WORKFORCE LOCATION DISTRIBUTION
-- OBJECTIVE:
-- Calculate employee distribution between
-- Headquarters and Remote locations.

USE project_hr_analytics;

SELECT
    location,
    COUNT(*) AS employee_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM HR),
        2
    ) AS percentage
FROM HR
GROUP BY location
ORDER BY employee_count DESC;
