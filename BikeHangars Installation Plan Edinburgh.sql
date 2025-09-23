USE portfolio;

-- Select the Data I am going to be Using

SELECT objectid, bikehangar, building_n, street, post_code, council_wa, installation
FROM secure_cycle_hangars
ORDER BY objectid;

-- Data Cleaning

UPDATE secure_cycle_hangars
SET council_wa = TRIM(council_wa);

UPDATE secure_cycle_hangars
SET council_wa = CONCAT(UCASE(LEFT(council_wa,1)), LCASE(SUBSTRING(council_wa,2)));

-- Removing Duplicates

DELETE a FROM secure_cycle_hangars a
JOIN secure_cycle_hangars b
  ON a.building_n = b.building_n
 AND a.street = b.street
 AND a.post_code = b.post_code
 AND a.objectid > b.objectid;

-- Unique Bikehangars

SELECT COUNT(DISTINCT bikehangar) AS unique_hangars
FROM secure_cycle_hangars;

-- Distinct Councils

SELECT COUNT(DISTINCT council_wa) AS total_councils
FROM secure_cycle_hangars;

-- Intsllation Duration

SELECT MIN(installation) AS first_install,
       MAX(installation) AS last_install
FROM secure_cycle_hangars;

-- Councils with Max. Installations

SELECT council_wa, COUNT(DISTINCT street) AS Max_Installation
FROM secure_cycle_hangars
-- Councils Like Morningside and Leith Walk have higher numbers of installation
GROUP BY council_wa
ORDER BY Max_Installation DESC;

-- Top 10 Busiest Streets

SELECT street, COUNT(*) AS total_hangars
FROM secure_cycle_hangars
GROUP BY street
ORDER BY total_hangars DESC
LIMIT 10;

-- Hangars by PostCodes

SELECT post_code, COUNT(*) AS total_bikehangars
FROM secure_cycle_hangars
GROUP BY post_code
ORDER BY total_bikehangars DESC; 

-- Installations before and after Pandamic

SELECT
    CASE
        WHEN installation >= '2022-01-01' THEN 'Recnt: AFTER COVID Installation'
        ELSE 'Older: During COVID Installation'
    END AS installation,
    SUM(1) AS installs   -- or COUNT(*) as installs
FROM secure_cycle_hangars
GROUP BY
    CASE
        WHEN installation >= '2022-01-01' THEN 'Recnt: AFTER COVID Installation'
        ELSE 'Older: During COVID Installation'
    END
ORDER BY installation DESC;

-- Busiest Areas

SELECT CONCAT(street, ', ', post_code) AS location, COUNT(*) AS hangar_count
FROM secure_cycle_hangars
-- Areas close to academics and universities are in higher in installation number
GROUP BY street, post_code
ORDER BY hangar_count DESC
LIMIT 10;

-- Lets Create Views for Visualization

CREATE VIEW maxInstallation AS
SELECT council_wa, COUNT(DISTINCT street) AS Max_Installation
FROM secure_cycle_hangars
GROUP BY council_wa
ORDER BY Max_Installation DESC;

CREATE VIEW busiestStreets AS
SELECT street, COUNT(*) AS total_hangars
FROM secure_cycle_hangars
GROUP BY street
ORDER BY total_hangars DESC
LIMIT 10;

CREATE VIEW InstallationCovideSplit AS
SELECT
    CASE
        WHEN installation >= '2022-01-01' THEN 'Recnt: AFTER COVID Installation'
        ELSE 'Older: During COVID Installation'
    END AS installation,
    SUM(1) AS installs   -- or COUNT(*) as installs
FROM secure_cycle_hangars
GROUP BY
    CASE
        WHEN installation >= '2022-01-01' THEN 'Recnt: AFTER COVID Installation'
        ELSE 'Older: During COVID Installation'
    END
ORDER BY installation DESC;

CREATE VIEW Top10Areas AS
SELECT CONCAT(street, ', ', post_code) AS location, COUNT(*) AS hangar_count
FROM secure_cycle_hangars
GROUP BY street, post_code
ORDER BY hangar_count DESC
LIMIT 10;
