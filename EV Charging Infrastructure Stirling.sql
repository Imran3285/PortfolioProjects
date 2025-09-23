USE PortfolioProject;

-- EV Charging Infrastructure in Stirling, UK

SELECT*,
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

-- Creating View for Later Visulisations

CREATE VIEW ChargingRatio AS
SELECT LOCATION, POSTCODE,
       COUNT(*) AS Chargers,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ev_chargers_stirling), 2) AS Pct_of_Total
FROM ev_chargers_stirling
GROUP BY LOCATION, POSTCODE;