USE road_accidents_india;

-- Creating Accident Table --
CREATE TABLE accidents(
	Accident_index INT PRIMARY KEY,
    longitude DOUBLE,
	latitude DOUBLE,
    Police_Force INT,
    Accident_Severity INT, 
    Number_of_Vehicles INT,
    Number_of_Casualties INT,
    Day_of_Week INT,
	Time TIME,
    Local_Authority_District INT,
    Local_Authority_Highway VARCHAR(20),
    1st_Road_Class INT,
    1st_Road_Number INT, 
    Road_Type INT,
    Speed_limit INT,
    Junction_Detail INT,
    Junction_Control INT,
    2nd_Road_Class INT,
    2nd_Road_Number INT,
    Pedestrian_Crossing_Human_Control INT,
    Pedestrian_Crossing_Physical_Facilities INT,
    Light_Conditions INT,
    Weather_Conditions INT,
    Road_Surface_Conditions INT,
    Special_Conditions_at_Site INT,
    Carriageway_Hazards INT,
    Urban_or_Rural_Area INT,
    Did_Police_Officer_Attend_Scene_of_Accident INT,
    LSOA_of_Accident_Location VARCHAR(20),
    Date DATE);
    SHOW TABLES;
    SELECT * FROM accidents;
    
     -- Creating Casualties Table --
    CREATE TABLE casualties(
		Accident_index INT,
		Vehicle_Reference INT,
		Casualty_Reference INT,
		Casualty_Class INT,
		Sex_of_Casualty INT,
		Age_of_Casualty INT,
		Age_Band_of_Casualty INT,
		Casualty_Severity INT,
		Pedestrian_Location INT,
		Pedestrian_Movement INT,
		Car_Passenger INT,
		Bus_or_Coach_Passenger INT,
		Pedestrian_Road_Maintenance_Worker INT, 
		Casualty_Type INT,
		Casualty_Home_Area_Type INT);
SHOW TABLES;
SELECT * FROM casualties;

  -- Creating Vehicles Table --
    CREATE TABLE vehicles(
	Accident_index INT,
    Vehicle_Reference INT,
	Vehicle_Type INT,
    Towing_and_Articulation INT,
    Vehicle_Manoeuvre INT,
    Vehicle_Location_Restricted_Lane INT,
    Junction_Location INT,
    Skidding_and_Overturning INT,
	Hit_Object_in_Carriageway INT,
    Vehicle_Leaving_Carriageway INT,
    Hit_Object_off_Carriageway INT,
    1st_Point_of_Impact INT,
    Was_Vehicle_Left_Hand_Drive INT, 
    Journey_Purpose_of_Driver INT,
    Sex_of_Driver INT,
    Age_of_Driver INT,
    Age_Band_of_Driver INT,
    Engine_Capacity_in_CC INT,
    Propulsion_Code INT,
    Age_of_Vehicle INT,
    Driver_IMD_Decile INT,
    Driver_Home_Area_Type INT);
SHOW TABLES;
SELECT * FROM vehicles;
    
-- Data Cleaning:
-- Removing redundant columns from Accident Table
select * from accidents;
ALTER TABLE accidents
	DROP COLUMN longitude,
	DROP COLUMN latitude,
	DROP COLUMN Police_force,
    DROP COLUMN Time,
    DROP COLUMN Local_Authority_Highway,
    DROP COLUMN 1st_Road_Class,
    DROP COLUMN 1st_Road_Number,
    DROP COLUMN Speed_limit,
    DROP COLUMN Junction_Detail,
    DROP COLUMN Junction_Control,
    DROP COLUMN 2nd_Road_Class,
    DROP COLUMN 2nd_Road_Number,
    DROP COLUMN Pedestrian_Crossing_Human_Control,
    DROP COLUMN Pedestrian_Crossing_Physical_Facilities,
    DROP COLUMN Light_Conditions,
    DROP COLUMN Special_Conditions_at_Site,
    DROP COLUMN Carriageway_Hazards,
    DROP COLUMN Did_Police_Officer_Attend_Scene_of_Accident,
    DROP COLUMN LSOA_of_Accident_Location;

-- Removing redundant columns from Casualties Table
select * from casualties;
ALTER TABLE casualties
	DROP COLUMN Vehicle_Reference,
	DROP COLUMN Casualty_Reference,
	DROP COLUMN Casualty_Class,
    DROP COLUMN Age_Band_of_Casualty,
    DROP COLUMN Pedestrian_Location,
    DROP COLUMN Pedestrian_Movement,
    DROP COLUMN Car_Passenger,
    DROP COLUMN Bus_or_Coach_Passenger,
    DROP COLUMN Pedestrian_Road_Maintenance_Worker,
    DROP COLUMN Casualty_Type,
    DROP COLUMN Casualty_Home_Area_Type;
    
-- Removing redundant columns from Vehicles Table
select * from vehicles;
ALTER TABLE vehicles
	DROP COLUMN Vehicle_Reference,
	DROP COLUMN Vehicle_Type,
	DROP COLUMN Towing_and_Articulation,
    DROP COLUMN Vehicle_Manoeuvre,
    DROP COLUMN Vehicle_Location_Restricted_Lane,
    DROP COLUMN Junction_Location,
    DROP COLUMN Skidding_and_Overturning,
    DROP COLUMN Hit_Object_in_Carriageway,
    DROP COLUMN Vehicle_Leaving_Carriageway,
    DROP COLUMN Hit_Object_off_Carriageway,
    DROP COLUMN 1st_Point_of_Impact,
    DROP COLUMN Was_Vehicle_Left_Hand_Drive,
    DROP COLUMN Journey_Purpose_of_Driver,
    DROP COLUMN Age_Band_of_Driver,
    DROP COLUMN Engine_Capacity_in_CC,
    DROP COLUMN Propulsion_Code,
    DROP COLUMN Age_of_Vehicle,
    DROP COLUMN Driver_IMD_Decile,
    DROP COLUMN Driver_Home_Area_Type;   
    
SELECT * FROM accidents
LIMIT 10;


SELECT * FROM casualties
LIMIT 10;   


SELECT * FROM vehicles
LIMIT 10;



-- Problem Statement: Analyze the distribution of Accidents and Casualties
SELECT COUNT(accident_index) AS Total_Accidents, SUM(Number_of_Casualties) AS Total_Casualties
FROM Accidents;


-- Task 1: Analyze the distributions of accidents, casualties caused over months and day

SELECT DATE_FORMAT(Date, '%m') AS Month, COUNT(accident_index) AS Accident_Count,
SUM(Number_of_Casualties) AS Total_Casualties FROM accidents
GROUP BY Month
ORDER BY Month;

SELECT Day_of_Week, COUNT(accident_index) AS Accident_Count,
SUM(Number_of_Casualties) AS Total_Casualties FROM accidents
GROUP BY Day_of_Week
ORDER BY Day_of_Week;  


-- Task 2: Analyze the distributiton of vehicles involved in accidents over months

SELECT DATE_FORMAT(Date, '%m') AS Month,
SUM(number_of_vehicles) AS Number_of_vehicles FROM accidents
GROUP BY Month
ORDER BY Month;


-- Task 3: Analyze the variations in accident_severity, casualties severity over months

SELECT DATE_FORMAT(a.Date, '%m') AS Month, ROUND(AVG(a.accident_severity)) AS Average_Accident_Severity,
ROUND(AVG(c.Casualty_Severity)) AS Average_Casualty_Severity FROM accidents a
INNER JOIN casualties c
ON a.Accident_index = c.Accident_index
GROUP BY month
ORDER BY month;


-- Task 4: Analyze the Distribution of Accidents and Casualties based on Accident Severity

SELECT Accident_Severity, COUNT(Accident_index) AS Accident_count, 
SUM(Number_of_Casualties) AS Total_Casualties FROM accidents
GROUP BY Accident_Severity
ORDER BY Accident_Severity;


-- Task 5: Identify Top 10 Local Authority District by Total Casualties and Total Accidents

SELECT ROW_NUMBER() OVER (ORDER BY Total_accidents DESC) AS Rank_,
Local_Authority_District, Total_Accidents, Total_Casualties FROM (
	SELECT Local_Authority_District, count(Accident_Index) AS Total_Accidents,
    sum(Number_of_Casualties) AS Total_Casualties
    FROM accidents
    GROUP BY Local_Authority_District
    ORDER BY Total_accidents DESC
    LIMIT 10) AS Ranked_Districts;
    

-- Task 6: Analyze the impact of Driver's Age on Accidents, Casualties and their Severity 
SELECT * FROM casualties;
SELECT
	CASE
		WHEN v.Age_of_Driver BETWEEN 0 AND 17 THEN '0-17'
        WHEN v.Age_of_Driver BETWEEN 18 AND 24 THEN '18-24'
        WHEN v.Age_of_Driver BETWEEN 25 AND 34 THEN '25-34'
        WHEN v.Age_of_Driver BETWEEN 35 AND 44 THEN '35-44'
        WHEN v.Age_of_Driver BETWEEN 45 AND 64 THEN '45-64'
        WHEN v.Age_of_Driver >= 65 THEN '65+'
        ELSE 'Unknown'
	END AS Age_Group, COUNT(a.Accident_index) AS Accident_count,
    SUM(a.Number_of_Casualties) AS Total_Casualties,
    ROUND(AVG(a.Accident_Severity)) AS Average_Accident_Severity,
    ROUND(AVG(Casualty_Severity)) AS Average_Casualty_Severity
    FROM accidents a
INNER JOIN vehicles v
ON a.Accident_index = v.Accident_index
INNER JOIN casualties c
ON a.Accident_index = c.Accident_index
GROUP BY Age_Group
ORDER BY Age_Group;


-- Task 7: Analyze the impact of Driver's Gender on Accidents, Casualties and their Severity.

SELECT v.Sex_of_Driver AS Driver_Gender, COUNT(a.accident_index) AS Accident_Count,
SUM(a.Number_of_Casualties) AS Total_Casualties,
ROUND(AVG(a.Accident_Severity)) AS Average_Accident_Severity,
ROUND(AVG(Casualty_Severity)) AS Average_Casualty_Severity
FROM accidents AS a
INNER JOIN vehicles AS v 
ON a.Accident_index = v.Accident_index
INNER JOIN casualties c
ON a.Accident_index = c.Accident_index
GROUP BY Driver_Gender;

-- Task 8: Analyze the impact of road types, Wheather Conditions and Road Surface Condition on Accidents

SELECT * FROM accidents;
SELECT Road_Type, COUNT(Accident_index) AS Accident_Count,
ROUND(AVG(Accident_Severity)) AS Average_Accident_Severity FROM accidents
GROUP BY Road_Type
ORDER BY Road_Type;


SELECT Weather_Conditions, COUNT(Accident_index) AS Accident_Count,
ROUND(AVG(Accident_Severity)) AS Average_Accident_Severity FROM accidents
GROUP BY Weather_Conditions
ORDER BY Weather_Conditions;

SELECT Road_Surface_Conditions, COUNT(Accident_index) AS Accident_Count,
ROUND(AVG(Accident_Severity)) AS Average_Accident_Severity FROM accidents
GROUP BY Road_Surface_Conditions
ORDER BY Road_Surface_Conditions;


-- Task 9: Analyze the distribution of casualties based on their Gender

SELECT c.sex_of_Casualty, SUM(a.number_of_casualties) AS Casulaties_Count FROM accidents a
INNER JOIN casualties c
ON a.Accident_index = c.Accident_index
GROUP BY Sex_of_Casualty
ORDER BY Sex_of_Casualty;


-- Task 10: Analyze the distribution of Accidents and Casualties in urban and rural areas

SELECT Urban_or_Rural_Area, COUNT(accident_index) AS Accident_Count FROM accidents
GROUP BY Urban_or_Rural_Area
ORDER BY Urban_or_Rural_Area; 

-- Task 11: Identify Top 10 Local Authority District by Accident and Casualty Severity
SELECT * FROM accidents;
SELECT * FROM casualties;

SELECT a.local_authority_district, ROUND(AVG(a.accident_severity)) AS Average_Accident_Severity,
ROUND(AVG(c.casualty_severity)) AS Average_Casualty_Severity FROM accidents a
INNER JOIN casualties c
ON a.accident_index = c.accident_index
GROUP BY a.local_authority_district
ORDER BY Average_Accident_Severity, Average_Casualty_Severity
LIMIT 10;

