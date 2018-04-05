-- a) TOTAL COST OF ALL EVENTS, DRILLED DOWN TO TOTAL COST OF EACH DISASTER TYPE
SELECT disastertype, GROUPING(disastertype), SUM(estimatedtotalcost) AS estimatedtotalcost
FROM fact
JOIN costs ON fact.costkey = costs.costskey
JOIN disaster ON fact.disasterkey = disaster.disasterkey
GROUP BY ROLLUP(disastertype)
ORDER BY grouping DESC;

-- b) NUMBER OF EVENTS OR NUMBER OF EVENT TYPE AT CITY, THEN ROLLED UP TO PROVINCE, THEN ROLLED UP TO COUNTRY (NOT COMPLETELY SURE IF YOU GUYS WANT THIS)
SELECT country, province, city, disastertype, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY GROUPING SETS((country, disastertype), (country, province, disastertype), ROLLUP(country, province, city, disastertype))
ORDER BY country, province, city, disastertype;

-- b) NUMBER OF EVACUATEE, FATALITIES, INJURED IN YEAR OR YEAR AND MONTH AT CITY, THEN ROLLED UP TO PROVINCE, THEN ROLLED UP TO COUNTRY
SELECT country, province, city, year, month, SUM(evacuated) AS evacuated, sum(fatalities) AS fatalities, sum(injured) AS injured
FROM fact
JOIN date ON fact.enddatekey = date.datekey
JOIN location ON fact.locationkey = location.locationkey
GROUP BY GROUPING SETS((country, province, city, year), (country, province, year), (country, year), (country, province, city, year, month), (country, province, year, month), (country, year, month))
ORDER BY country, province, city, year, month;

-- c) NUMBER OF EACH DISASTER TYPE IN ONTARIO SLICE
SELECT DISTINCT disaster.disastertype, coalesce(t.province, 'Ontario'), coalesce(count, 0)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
LEFT JOIN (SELECT disastertype, province, COUNT(*) as count
	  FROM fact
	  JOIN disaster ON fact.disasterkey = disaster.disasterkey
	  JOIN location ON fact.locationkey = location.locationkey
	  WHERE province = 'Ontario'
	  GROUP BY disastertype, province) as t ON disaster.disastertype = t.disastertype

-- d) NUMBER OF FLOODS IN TORONTO DICE
SELECT disastertype, city, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN location ON fact.locationkey = location.locationkey
WHERE disastertype = 'Flood' AND city = 'Toronto'
GROUP BY disastertype, city;

-- e) TOP 5 MOST FREQUENT DISASTER TYPE
SELECT disastertype, COUNT(*)
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
GROUP BY disastertype
ORDER BY COUNT DESC
LIMIT 5;

-- e) TOP 5 MOST EXPENSIVE DISASTER TYPE
SELECT disastertype, SUM(estimatedtotalcost) AS estimatedtotalcost
FROM fact
JOIN disaster ON fact.disasterkey = disaster.disasterkey
JOIN costs ON fact.costkey = costs.costskey
WHERE estimatedtotalcost IS NOT NULL
GROUP BY disastertype
ORDER BY estimatedtotalcost DESC
LIMIT 5;