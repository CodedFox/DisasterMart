SELECT f.fatalities, f.injured, f.evacuated, 
l.city, l.province, l.region, l.country, l.canada, 
d.disastertype, d.disastersubgroup, d.disastergroup, d.disastercategory, d.magnitude, d.utilitypeopleaffected,
sd.day AS start_day, sd.week AS start_week, sd.month AS start_month, sd.year AS start_year, sd.weekend AS start_weekend, sd.seasoncanada AS start_seasoncanada, sd.seasoninternational AS start_seasoninternational,
ed.day AS end_day, ed.week AS end_week, ed.month AS end_month, ed.year AS end_year, ed.weekend AS end_weekend, ed.seasoncanada AS end_seasoncanada, ed.seasoninternational AS end_seasoninternational,
c.estimatedtotalcost, c.normalizedtotalcost, c.federaldfaapayments, c.provincialdfaapayments, c.provincialdepartmentpayments, c.municipalcosts, c.ogdcosts, c.insurancepayments, c.ngopayments,
s.keyword1, s.keyword2, s.keyword3
FROM fact f
INNER JOIN location l ON f.locationkey = l.locationkey
INNER JOIN disaster d ON f.disasterkey = d.disasterkey
INNER JOIN date sd ON f.startdatekey = sd.datekey
INNER JOIN date ed ON f.enddatekey = ed.datekey
INNER JOIN costs c ON f.costkey = c.costskey
INNER JOIN summary s ON f.descriptionkey = s.descriptionkey;