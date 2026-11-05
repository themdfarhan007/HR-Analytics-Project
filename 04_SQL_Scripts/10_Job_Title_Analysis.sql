-- Select the HR Analytics database
USE project_hr_analytics;

-- Analyse employee distribution by job title
SELECT
    jobtitle,
    COUNT(*) AS total_employees,
    ROUND(
        COUNT(*) * 100.0 / (SELECT COUNT(*) FROM HR),
        2
    ) AS employee_percentage
FROM HR
GROUP BY jobtitle
ORDER BY total_employees DESC;

-- Select the HR Analytics database
USE project_hr_analytics;

-- Validate job title data
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT jobtitle) AS unique_job_titles,
    COUNT(jobtitle) AS non_null_jobtitles,
    SUM(
        CASE
            WHEN jobtitle IS NULL OR TRIM(jobtitle) = ''
            THEN 1
            ELSE 0
        END
    ) AS missing_jobtitles
FROM HR;