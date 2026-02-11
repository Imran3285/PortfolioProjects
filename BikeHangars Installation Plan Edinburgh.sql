USE portfolio;

-------------------------------------------------
-- Select the main fields we will analyse
-------------------------------------------------
SELECT objectid, bikehangar, building_n, street, post_code, council_wa, installation
FROM secure_cycle_hangars
ORDER BY objectid;

-------------------------------------------------
-- Data Cleaning
-------------------------------------------------

-- Remove extra spaces from council names
UPDATE secure_cycle_hangars
SET council_wa = TRIM(council_wa);

-- Standardise council name format (Capital first letter)
UPDATE secure_cycle_hangars
SET council_wa = CONCAT(
    UCASE(LEFT(council_wa,1)), 
    LCASE(SUBSTRING(council_wa,2))
);

-------------------------------------------------
-- Remove duplicate records
-- (same building, street and postcode = duplicate)
-------------------------------------------------
DELETE a 
FROM secure_cycle_hangars a
JOIN secure_cycle_hangars b
  ON a.building_n = b.building_n
 AND a.street = b.street
 AND a.post_code = b.post_code
 AND a.objectid > b.objectid;

-------------------------------------------------
-- Data Quality Checks
-------------------------------------------------

SELECT 
    COUNT(*) AS total_records,
    COUNT(installation) AS valid_dates,
    COUNT(post_code) AS valid_postcodes,
    COUNT(DISTINCT post_code) AS postcode_uniqueness,
    COUNT(DISTINCT street) AS street_uniqueness
FROM secure_cycle_hangars;

-------------------------------------------------
-- Basic Metrics
-------------------------------------------------

-- Total unique bike hangars
SELECT COUNT(DISTINCT bikehangar) AS unique_hangars
FROM secure_cycle_hangars;

-- Total number of councils covered
SELECT COUNT(DISTINCT council_wa) AS total_councils
FROM secure_cycle_hangars;

-- First and last installation dates
SELECT 
    MIN(installation) AS first_install,
    MAX(installation) AS last_install
FROM secure_cycle_hangars;

-------------------------------------------------
-- Council-Level Analysis
-------------------------------------------------

-- Councils with the highest number of installations
SELECT 
    council_wa, 
    COUNT(DISTINCT street) AS max_installation
FROM secure_cycle_hangars
GROUP BY council_wa
ORDER BY max_installation DESC;

-------------------------------------------------
-- Street-Level Analysis
-------------------------------------------------

-- Top 10 streets with most bike hangars
SELECT 
    street, 
    COUNT(*) AS total_hangars
FROM secure_cycle_hangars
GROUP BY street
ORDER BY total_hangars DESC
LIMIT 10;

-------------------------------------------------
-- Postcode-Level Analysis
-------------------------------------------------

-- Bike hangars by postcode
SELECT 
    post_code, 
    COUNT(*) AS total_bikehangars
FROM secure_cycle_hangars
GROUP BY post_code
ORDER BY total_bikehangars DESC;

-------------------------------------------------
-- COVID Impact Analysis
-------------------------------------------------

-- Installations before and after COVID
SELECT
    CASE
        WHEN installation >= '2022-01-01' 
            THEN 'Recent: After COVID'
        ELSE 'Older: During COVID'
    END AS installation_period,
    COUNT(*) AS installs
FROM secure_cycle_hangars
GROUP BY installation_period
ORDER BY installs DESC;

-------------------------------------------------
-- Area-Level Density
-------------------------------------------------

-- Busiest areas (street + postcode)
SELECT 
    CONCAT(street, ', ', post_code) AS location, 
    COUNT(*) AS hangar_count
FROM secure_cycle_hangars
GROUP BY street, post_code
ORDER BY hangar_count DESC
LIMIT 10;

-------------------------------------------------
-- Views for Dashboards & Visualisation
-------------------------------------------------

-- Council installations view
CREATE VIEW maxInstallation AS
SELECT 
    council_wa, 
    COUNT(DISTINCT street) AS max_installation
FROM secure_cycle_hangars
GROUP BY council_wa;

-- Busiest streets view
CREATE VIEW busiestStreets AS
SELECT 
    street, 
    COUNT(*) AS total_hangars
FROM secure_cycle_hangars
GROUP BY street
ORDER BY total_hangars DESC
LIMIT 10;

-- COVID split view
CREATE VIEW InstallationCovidSplit AS
SELECT
    CASE
        WHEN installation >= '2022-01-01' 
            THEN 'Recent: After COVID'
        ELSE 'Older: During COVID'
    END AS installation_period,
    COUNT(*) AS installs
FROM secure_cycle_hangars
GROUP BY installation_period;

-- Top areas view
CREATE VIEW Top10Areas AS
SELECT 
    CONCAT(street, ', ', post_code) AS location, 
    COUNT(*) AS hangar_count
FROM secure_cycle_hangars
GROUP BY street, post_code
ORDER BY hangar_count DESC
LIMIT 10;

-------------------------------------------------
-- Advanced Analytics
-------------------------------------------------

-- Council market share (% of total infrastructure)
SELECT 
    council_wa,
    COUNT(*) AS total_installs,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 
        2
    ) AS market_share_percent
FROM secure_cycle_hangars
GROUP BY council_wa
ORDER BY market_share_percent DESC;

-- Council ranking by installations
SELECT 
    council_wa,
    COUNT(*) AS total_installs,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS council_rank
FROM secure_cycle_hangars
GROUP BY council_wa;

-------------------------------------------------
-- Urban Density Zones
-------------------------------------------------

SELECT 
    post_code,
    COUNT(*) AS hangar_density,
    CASE
        WHEN COUNT(*) >= 10 THEN 'High Density'
        WHEN COUNT(*) BETWEEN 5 AND 9 THEN 'Medium Density'
        ELSE 'Low Density'
    END AS density_zone
FROM secure_cycle_hangars
GROUP BY post_code
ORDER BY hangar_density DESC;

-------------------------------------------------
-- Accessibility / Equity Model
-------------------------------------------------

SELECT 
    street,
    COUNT(*) AS hangars,
    COUNT(DISTINCT post_code) AS postcode_coverage,
    (COUNT(*) * COUNT(DISTINCT post_code)) AS accessibility_score
FROM secure_cycle_hangars
GROUP BY street
ORDER BY accessibility_score DESC;

-------------------------------------------------
-- Policy Period Analysis
-------------------------------------------------

SELECT 
    CASE
        WHEN installation < '2020-03-01' THEN 'Pre-COVID'
        WHEN installation BETWEEN '2020-03-01' AND '2021-12-31' THEN 'COVID Period'
        ELSE 'Post-COVID'
    END AS policy_period,
    COUNT(*) AS installs
FROM secure_cycle_hangars
GROUP BY policy_period
ORDER BY installs DESC;

-------------------------------------------------
-- Growth & Performance Views
-------------------------------------------------

-- Infrastructure growth over time
CREATE VIEW InfrastructureGrowth AS
WITH monthly AS (
    SELECT 
        DATE_FORMAT(installation, '%Y-%m') AS install_month,
        COUNT(*) AS installs
    FROM secure_cycle_hangars
    GROUP BY install_month
)
SELECT 
    install_month,
    installs,
    SUM(installs) OVER (ORDER BY install_month) AS cumulative_installs
FROM monthly;

-- Council performance dashboard view
CREATE VIEW CouncilPerformance AS
SELECT 
    council_wa,
    COUNT(*) AS total_installs,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS council_rank,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 
        2
    ) AS market_share_percent
FROM secure_cycle_hangars
GROUP BY council_wa;

-- Infrastructure density view
CREATE VIEW InfrastructureDensity AS
SELECT 
    post_code,
    COUNT(*) AS hangar_density,
    CASE
        WHEN COUNT(*) >= 10 THEN 'High Density'
        WHEN COUNT(*) BETWEEN 5 AND 9 THEN 'Medium Density'
        ELSE 'Low Density'
    END AS density_zone
FROM secure_cycle_hangars
GROUP BY post_code;