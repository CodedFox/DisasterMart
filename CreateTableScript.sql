/*
drop table date;
drop table disaster;
drop table summary;
drop table location;
drop table fact;
drop table costs;
*/
CREATE TABLE DATE (
	DateKey int primary key,
	Day int,
	Month int,
	Year int,
	Weekend boolean,
	SeasonCanada varchar(20),
	SeasonInternational varchar(20)
);

create table DISASTER (
	DisasterKey int primary key,
	DisasterType varchar(50),
	DisasterSubgroup varchar(50),
	DisasterGroup varchar(50),
	DisasterCategory varchar(50),
	Magnitude int,
	UtilityPeopleAffected int
);

Create table SUMMARY(
	DescriptionKey int primary key,
	Summary varchar(300),
	Keyword1 varchar(100),
	Keyword2 varchar(100),
	Keyword3 varchar(100)
);

Create table LOCATION(
	LocationKey int primary key,
	City varchar(100),
	Province varchar(100),
	Region varchar(100),
	Country varchar(100),
	Canada boolean
);

Create table COSTS(
	CostsKey int primary key,
	EstimatedTotalCost int,
	NormalizedTotalCost numeric,
	FederalDFAAPayments int,
	ProvincialDFAAPayments int,
	ProvincialDepartmentPayments int,
	MunicipalCosts int,
	OGDCosts int,
	InsurancePayments int,
	NGOPayments int
);

Create table FACT(
	StartDateKey int,
	EndDateKey int,
	LocationKey int,
	DisasterKey int,
	DescriptionKey int,
	CostKey int,
	--PopStatsKey int,
	--WeatherKey int,
	Fatalities int,
	Injured int,
	Evacuated int,
	PRIMARY KEY(StartDateKey,EndDateKey,LocationKey,DisasterKey,DescriptionKey,CostKey)
);

/*Create table WeatherInfo(
	WeatherKey int primary key
);

Create table PopulationStats(
	PopStatsKey int primary key
);*/