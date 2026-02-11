/********************************************************************
URBAN INFRASTRUCTURE DATA ANALYSIS – SQL PORTFOLIO PROJECT
Author: Muhammad Imran
Target Role: Data Analyst / Graduate Role

This portfolio project contains two infrastructure analytics case studies:

1) EV Charging Infrastructure – Stirling, UK
2) Secure Cycle Hangar Infrastructure

Core Skills Demonstrated:
- Data Cleaning & Standardisation
- Duplicate Removal
- Data Quality Validation
- Aggregations & Grouping
- CASE Logic & Classification
- Window Functions (RANK, SUM OVER)
- CTEs
- View Creation for Dashboards
- Policy & Growth Analysis
********************************************************************/



/********************************************************************
PROJECT 1: EV CHARGING INFRASTRUCTURE ANALYSIS
Location: Stirling, UK

Objective:
Analyse charger distribution, accessibility, density,
and postcode-level infrastructure coverage.
********************************************************************/

USE PortfolioProject;

-- EV Charging Infrastructure in Stirling, UK

SELECT *,
CASE
    WHEN charger_type LIKE '%50kW%' OR charger_type LIKE '%Rapid%' THEN 'Rapid'
    WHEN charger_type LIKE '%22%' THEN 'Fast'
    WHEN charger_type LIKE '%7%' OR charger_type LIKE '%Slow%' THEN 'Slow'
    ELSE 'Unknown'
END as Charging_Speed
FROM ev_chargers_stirling;

-- Checking Data Quality

SELECT CHARGERPLACE_ID, COUNT(*) AS duplicates
FROM ev_chargers_stirling
GROUP BY CHARGERPLACE_ID
HAVING COUNT(*) > 1;

-- Identify NULL Values

SELECT 
  SUM(CASE WHEN POSTCODE IS NULL THEN 1 ELSE 0 END) AS null_postcodes,
  SUM(CASE WHEN CHARGER_TYPE IS NULL THEN 1 ELSE 0 END) AS null_types
FROM ev_chargers_stirling;

-- Distribution of Charger Types

SELECT CHARGER_TYPE, Count(*) AS total
FROM ev_chargers_stirling
WHERE CHARGER_TYPE IS NOT NULL
GROUP BY CHARGER_TYPE
ORDER BY total DESC;

-- Common Charger Types Per Location

SELECT LOCATION, CHARGER_TYPE, COUNT(*) AS total
FROM ev_chargers_stirling
GROUP BY LOCATION, CHARGER_TYPE
ORDER BY total DESC;

-- Chargers Accessibility by PostCode

SELECT POSTCODE, COUNT(*) AS total_chargers
FROM ev_chargers_stirling
GROUP BY POSTCODE
ORDER BY total_chargers DESC;

-- Underserved Area

SELECT POSTCODE, COUNT(*) AS total_count
FROM ev_chargers_stirling
GROUP BY POSTCODE
HAVING COUNT(*) = 1;

-- Chargers Having Disabled Access

SELECT *
FROM ev_chargers_stirling
WHERE COMMENTS LIKE '%Dis%';

-- Location-based Insights

SELECT LOCATION, POSTCODE,
       COUNT(*) AS Chargers,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ev_chargers_stirling), 2) AS Pct_of_Total
FROM ev_chargers_stirling
GROUP BY LOCATION, POSTCODE
ORDER BY chargers DESC
LIMIT 5;

-- Creating View for Later Visualisations

CREATE VIEW ChargingRatio AS
SELECT LOCATION, POSTCODE,
       COUNT(*) AS Chargers,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ev_chargers_stirling), 2) AS Pct_of_Total
FROM ev_chargers_stirling
GROUP BY LOCATION, POSTCODE;



/********************************************************************
PROJECT 2: SECURE CYCLE HANGAR INFRASTRUCTURE ANALYSIS

Objective:
Evaluate installation growth, council performance,
density zones, accessibility modelling,
and policy period impact.
********************************************************************/

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

SELECT COUNT(DISTINCT bikehangar) AS unique_hangars
FROM secure_cycle_hangars;

SELECT COUNT(DISTINCT council_wa) AS total_councils
FROM secure_cycle_hangars;

SELECT 
    MIN(installation) AS first_install,
    MAX(installation) AS last_install
FROM secure_cycle_hangars;

-------------------------------------------------
-- Council-Level Analysis
-------------------------------------------------

SELECT 
    council_wa, 
    COUNT(DISTINCT street) AS max_installation
FROM secure_cycle_hangars
GROUP BY council_wa
ORDER BY max_installation DESC;

-------------------------------------------------
-- Street-Level Analysis
-------------------------------------------------

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

SELECT 
    post_code, 
    COUNT(*) AS total_bikehangars
FROM secure_cycle_hangars
GROUP BY post_code
ORDER BY total_bikehangars DESC;

-------------------------------------------------
-- COVID Impact Analysis
-------------------------------------------------

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

CREATE VIEW maxInstallation AS
SELECT 
    council_wa, 
    COUNT(DISTINCT street) AS max_installation
FROM secure_cycle_hangars
GROUP BY council_wa;

CREATE VIEW busiestStreets AS
SELECT 
    street, 
    COUNT(*) AS total_hangars
FROM secure_cycle_hangars
GROUP BY street
ORDER BY total_hangars DESC
LIMIT 10;

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
