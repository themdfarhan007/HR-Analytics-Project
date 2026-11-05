-- STEP 49 A: CITY-WISE EMPLOYEE DISTRIBUTION
-- OBJECTIVE:
-- Calculate employee distribution across cities
-- and states for Power BI geographical analysis.
--
-- City and state are both included to distinguish
-- cities that share the same name.

USE project_hr_analytics;

SELECT
    location_city,
    location_state,
    COUNT(*) AS employee_count
FROM HR
GROUP BY
    location_city,
    location_state
ORDER BY employee_count DESC;


-- STEP 49 B: COUNT CITY-STATE COMBINATIONS
-- OBJECTIVE:
-- Identify the total number of unique city-state
-- combinations in the HR dataset.

USE project_hr_analytics;

SELECT
    COUNT(*) AS total_city_state_combinations
FROM
(
    SELECT DISTINCT
        location_city,
        location_state
    FROM HR
) AS city_state;

