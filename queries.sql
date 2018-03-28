-- 1 TOTAL COST
SELECT SUM(estimatedtotalcost) AS estimatedtotalcost
FROM fact
JOIN costs ON fact.costkey = costs.costskey;
-- 1 TOTAL COST PER EVENT TYPE
SELECT disastertype, SUM(estimatedtotalcost) AS estimatedtotalcost
FROM fact
JOIN costs ON fact.costkey = costs.costskey
JOIN disaster ON fact.disasterkey = disaster.disasterkey
GROUP BY disastertype;
-- 1 TOTAL COST PER EVENT
SELECT estimatedtotalcost
FROM fact 
JOIN costs ON fact.costkey = costs.costskey;

-- 2 NUMBER OF EVENT TYPE AT COUNTRY
SELECT disastertype, country, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY disastertype, country;
-- 2 NUMBER OF EVENT TYPE AT PROVINCE
SELECT disastertype, province, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY disastertype, province;
-- 2 NUMBER OF EVENT TYPE AT CITY
SELECT disastertype, city, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY disastertype, city;
-- 2 EVENTS AT COUNTRY
SELECT country, COUNT(*)
FROM fact
JOIN location ON fact.locationkey = location.locationkey
GROUP BY country;
-- 2 EVENTS AT PROVINCE
SELECT province, COUNT(*)
FROM fact
JOIN location ON fact.locationkey = location.locationkey
GROUP BY province;
-- 2 EVENTS AT CITY
SELECT city, COUNT(*)
FROM fact
JOIN location ON fact.locationkey = location.locationkey
GROUP BY city;

-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN YEAR AT COUNTRY
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, year, country
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY year, country;
-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN YEAR AT PROVINCE
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, year, province
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY year, province;
-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN YEAR AT CITY
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, year, city
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY year, city;
-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN MONTH AT COUNTRY
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, month, country
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY month, country;
-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN MONTH AT PROVINCE
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, month, province
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY month, province;
-- 3 NUMBER OF EVACUATEE, FATALITIES, INJURED IN MONTH AT CITY
SELECT SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured, month, city
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY month, city;

-- 4 EVENT TYPE OCCURANCES
SELECT disastertype, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
GROUP BY disastertype
ORDER BY COUNT DESC
LIMIT 5;
-- 4 EVENT TYPE COST
SELECT disastertype, SUM(estimatedtotalcost) AS estimatedtotalcost
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN costs ON fact.costkey = costs.costskey
WHERE estimatedtotalcost IS NOT NULL
GROUP BY disastertype
ORDER BY estimatedtotalcost DESC
LIMIT 5;