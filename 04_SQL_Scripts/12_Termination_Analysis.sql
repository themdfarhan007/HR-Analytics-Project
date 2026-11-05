-- PROJECT: HR ANALYTICS
-- FILE: 12_Termination_Analysis.sql
-- REFERENCE DATE: 03 NOVEMBER 2026
-- PURPOSE: Analyse termination patterns and validate completed and future
-- termination dates. The termdate source values contain a trailing ' UTC'.

USE project_hr_analytics;


-- QUERY 1: ALL VALID TERMINATION DATES GROUPED BY YEAR
-- Includes completed and future-dated termination records.

SELECT
    YEAR(
        STR_TO_DATE(
            REPLACE(termdate, ' UTC', ''),
            '%Y-%m-%d %H:%i:%s'
        )
    ) AS termination_year,
    COUNT(*) AS total_terminations
FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) IS NOT NULL
GROUP BY termination_year
ORDER BY termination_year;


-- QUERY 2: COMPLETED TERMINATIONS GROUPED BY YEAR
-- Excludes termination dates after the project reference date.

SELECT
    YEAR(
        STR_TO_DATE(
            REPLACE(termdate, ' UTC', ''),
            '%Y-%m-%d %H:%i:%s'
        )
    ) AS termination_year,
    COUNT(*) AS completed_terminations
FROM HR
WHERE termdate IS NOT NULL
  AND TRIM(termdate) <> ''
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) IS NOT NULL
  AND STR_TO_DATE(
      REPLACE(termdate, ' UTC', ''),
      '%Y-%m-%d %H:%i:%s'
  ) <= '2026-11-03 23:59:59'
GROUP BY termination_year
ORDER BY termination_year;


-- QUERY 3: VALIDATE TOTAL, COMPLETED, AND FUTURE TERMINATION RECORDS

SELECT
    COUNT(*) AS total_employee_records,

    SUM(
        CASE
            WHEN termdate IS NOT NULL
             AND TRIM(termdate) <> ''
             AND STR_TO_DATE(
                 REPLACE(termdate, ' UTC', ''),
                 '%Y-%m-%d %H:%i:%s'
             ) IS NOT NULL
             AND STR_TO_DATE(
                 REPLACE(termdate, ' UTC', ''),
                 '%Y-%m-%d %H:%i:%s'
             ) <= '2026-11-03 23:59:59'
            THEN 1
            ELSE 0
        END
    ) AS completed_terminations,

    SUM(
        CASE
            WHEN termdate IS NOT NULL
             AND TRIM(termdate) <> ''
             AND STR_TO_DATE(
                 REPLACE(termdate, ' UTC', ''),
                 '%Y-%m-%d %H:%i:%s'
             ) IS NOT NULL
             AND STR_TO_DATE(
                 REPLACE(termdate, ' UTC', ''),
                 '%Y-%m-%d %H:%i:%s'
             ) > '2026-11-03 23:59:59'
            THEN 1
            ELSE 0
        END
    ) AS future_termination_dates

FROM HR;
