create table road_accident
(
accident_index varchar(50),
accident_date Date,
day_of_week varchar(20),
junction_control varchar(70),
junction_detail varchar(70),
accident_severity varchar(50),
light_conditions varchar(60),
local_authority varchar(50),
carriageway_hazards	 varchar(60),
number_of_casualties numeric(5,2),
number_of_vehicles numeric(5,2),
police_force varchar(50),
road_surface_conditions varchar(40),
road_type	varchar(50),
speed_limit	numeric(5,2),
time TIME,
urban_or_rural_area	 varchar(50),
weather_conditions varchar(50),
vehicle_type varchar(60)
);

Select * from road_accident ;

-- Total Casualties 
Select sum(number_of_casualties) as CY_casualties from road_accident ;
-- Current Year Casualties where year = 2022 
Select sum(number_of_casualties) as CY_casualties from road_accident where extract(year from accident_date) = '2022' ; 
Select sum(number_of_casualties) as CY_casualties from road_accident where extract(year from accident_date) = '2021' ;
-- Year Casualties where year=2022 and road_surface_condition = Dry 
Select sum(number_of_casualties) as casualties from road_accident where extract(year from accident_date) = '2022' and
road_surface_conditions = 'Dry';

Select sum(number_of_casualties) as casualties from road_accident where extract(year from accident_date) = '2021' and
road_surface_conditions = 'Dry' ;


-- Decrement in casualties to current year to Parent Year 
Select sum(number_of_casualties) as casualties from road_accident where 
extract(year from accident_date) = extract(year from accident_date)-1;


-- Total Casualties where year = 2022 and accident_severity = Fatal 
Select sum(number_of_casualties) as Cy_casualties from road_accident where extract(year from accident_date) = '2022' 
and accident_severity = 'Fatal'; 

Select sum(number_of_casualties) as CY_casualties from road_accident where accident_severity = 'Fatal';

-- Total Casualties where year = 2022 and accident_severity = Serious
Select sum(number_of_casualties) as Cy_casualties from road_accident where extract(year from accident_date) = '2022' 
and accident_severity = 'Serious';



-- What percentage of total casualties came from "Slight" accidents.
SELECT 
    CAST(
        (
            CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100
            /
            (
                SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2))
                FROM road_accident
            )
        ) AS DECIMAL(10,2)
    ) AS slight_percentage
FROM road_accident
WHERE accident_severity = 'Slight';


-- What percentage of total casualties came from "Serious" accidents.
SELECT
    CAST(
        (
            CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100
            /
            (
                SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2))
                FROM road_accident
            )
        ) AS DECIMAL(10,2)
    ) AS serious_percentage
FROM road_accident
WHERE accident_severity = 'Serious';


-- What percentage of total casualties came from "Fatal" accidents.
SELECT
    CAST(
        (
            CAST(SUM(number_of_casualties) AS DECIMAL(10,2)) * 100
            /
            (
                SELECT CAST(SUM(number_of_casualties) AS DECIMAL(10,2))
                FROM road_accident
            )
        ) AS DECIMAL(10,2)
    ) AS serious_percentage
FROM road_accident
WHERE accident_severity = 'Fatal';







-- Casualties by Vehicle type .....
Select 
	case	
		when vehicle_type in ('Agricultural vehicle')
		then 'Agricultural'
		when vehicle_type in ('Car','Taxi/Private hire car') 
		then 'Cars'
		when vehicle_type in ('Motorcycle 125cc and under','Motorcycle 50cc and under',
		'Motorcycle over 125cc and up to 500cc','Pedal cycle','Motorcycle over 500cc')
		then 'Bike'
		when vehicle_type in ('Minibus (8 - 16 passenger seats)','Bus or coach (17 or more pass seats)')
		then 'Bus'
		when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t')
		then  'Van'
		else 'Other'
		end as
		Vehicle_group,sum(number_of_casualties) as CY_Casualties 
		from road_accident 
		where extract(year from accident_date) = '2022'
		group by 
		(
case	
		when vehicle_type in ('Agricultural vehicle')
		then 'Agricultural'
		when vehicle_type in ('Car','Taxi/Private hire car') 
		then 'Cars'
		when vehicle_type in ('Motorcycle 125cc and under','Motorcycle 50cc and under',
		'Motorcycle over 125cc and up to 500cc','Pedal cycle','Motorcycle over 500cc')
		then 'Bike'
		when vehicle_type in ('Minibus (8 - 16 passenger seats)','Bus or coach (17 or more pass seats)')
		then 'Bus'
		when vehicle_type in ('Goods 7.5 tonnes mgw and over','Goods over 3.5t. and under 7.5t')
		then  'Van'
		else 'Other'
		end
		)
		order by cy_casualties desc ;






-- Select Current year 2022 Casualties according to month 
SELECT  
    TO_CHAR(accident_date, 'Month') AS month_name,
    SUM(number_of_casualties) AS total_casualties
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY TO_CHAR(accident_date, 'Month'),
         EXTRACT(MONTH FROM accident_date)
ORDER BY EXTRACT(MONTH FROM accident_date);



-- Select Total Casualties of Previous year according to month ....
Select to_char(accident_date,'month') as accident_month,
		sum(number_of_casualties) as CY_Casualties 
		from road_accident 
		where extract(year from accident_date) = 2021
		group by to_char(accident_date,'month'),
		extract(month from accident_date) 
		order by extract(month from accident_date) ;




-- Casualties for Roadtype 
	Select  distinct road_type as road_type , sum(number_of_casualties) as total_casualties
	from road_accident where extract(year from accident_date) = 2022
	group by road_type order by total_casualties desc ; 



-- Casualties by Urban and Rural 
Select distinct urban_or_rural_area as Region , sum(number_of_casualties) from road_accident where extract(year from accident_date)=2022
group by Region ;


-- Casualties Percentage by Urban and Rural where  Year = 2022 .....
 
-- Select distinct urban_or_rural_area as Region , (sum(number_of_casualties)*100/(select sum(number_of_casualties))) as Casualties_Percentage from road_accident)
-- from road_accident where extract(year from accident_date) = 2022 group by urban_or_rural_area order by Casualties_Percentage desc ;\
SELECT 
    urban_or_rural_area AS Region,
	sum(number_of_casualties) as Total_casualties,
    ROUND(
        SUM(number_of_casualties) * 100.0 /
        (
            SELECT SUM(number_of_casualties)
            FROM road_accident
            WHERE EXTRACT(YEAR FROM accident_date) = 2022
        ),
        2
    ) AS Casualties_Percentage
FROM road_accident
WHERE EXTRACT(YEAR FROM accident_date) = 2022
GROUP BY urban_or_rural_area
ORDER BY Casualties_Percentage DESC;



-- Percentage of Casualties irrespective of year ....
SELECT 
    urban_or_rural_area AS Region,
	sum(number_of_casualties) as Total_casualties,
    ROUND(
        SUM(number_of_casualties) * 100.0 /
        (
            SELECT SUM(number_of_casualties)
            FROM road_accident
        ),
        2
    ) AS Casualties_Percentage
FROM road_accident
GROUP BY urban_or_rural_area
ORDER BY Casualties_Percentage DESC;



-- Top 10 Location by number of Casualities 
Select * from road_accident ; 
Select distinct local_authority as locattion,sum(number_of_casualties) as Total_casualties
from road_accident group by locattion order by Total_casualties desc limit 10;


-- Number of casualties only in fine weather conditions .
Select * from road_accident ; 

Select case 
	when weather_conditions in ('Fine no high winds','Fine + high winds')
	then 'Fine'
	else 'Others'
end as Fine_weather_casualties , sum(number_of_casualties) as Total_casualties from 
road_accident group by (case 
	when weather_conditions in ('Fine no high winds','Fine + high winds')
	then 'Fine'
	else 'Others'
end)  ;

Select * from road_accident ; 

-- Number of Casualties by the group of Police Force and where vehicle type is Car or bike ......
Select case 
when Police_Force in ('Metropolitan Police','City of London')
then 'Metropolitan'
when Police_Force in ('Cumbria','Lanchashire','Merseyside','Greater Manchester','Cheshire','Northumbria',
						'Durham','North Yorkshire','West Yorkshire','South Yorkshire','Humberside',
						'Cleveland','West Midlands','Staffordshire','West Mercia','Warwickshire','Derbyshire',
						'Nottinghamshire','Loncolnshire','Leicestershire','Northamptonshire','Cambridgeshire',
						'Norfolk','Suffolk','Bedfordshire','Hertfordshire','Essex','Thames Valley','Hampshire','Surrey')
then 'terresterial'
when Police_Force in ('kent','Sussex','Devon and Cornwall','Avon and Somerset','Gloucestershire','Wiltshire',
						'Dorset','North Wales','Dyfed-Powys','Northern','Grampian','Tayside')
then 'Caremonial'
when Police_Force in ('Fife','Lothian and Borders','Central','Strathclyde','Dumfries and Galloway')
then 'Scottish'
else 'others'
end as Police , sum(number_of_casualties) as total_casualties from road_accident where urban_or_rural_area = 'Rural'

group by (case 
when Police_Force in ('Metropolitan Police','City of London')
then 'Metropolitan'
when Police_Force in ('Cumbria','Lanchashire','Merseyside','Greater Manchester','Cheshire','Northumbria',
						'Durham','North Yorkshire','West Yorkshire','South Yorkshire','Humberside',
						'Cleveland','West Midlands','Staffordshire','West Mercia','Warwickshire','Derbyshire',
						'Nottinghamshire','Loncolnshire','Leicestershire','Northamptonshire','Cambridgeshire',
						'Norfolk','Suffolk','Bedfordshire','Hertfordshire','Essex','Thames Valley','Hampshire','Surrey')
then 'terresterial'
when Police_Force in ('kent','Sussex','Devon and Cornwall','Avon and Somerset','Gloucestershire','Wiltshire',
						'Dorset','North Wales','Dyfed-Powys','Northern','Grampian','Tayside')
then 'Caremonial'
when Police_Force in ('Fife','Lothian and Borders','Central','Strathclyde','Dumfries and Galloway')
then 'Scottish'
else 'others'
end
);


Select * from road_accident ; 
Select sum(number_of_casualties),extract(month from accident_date) as month from road_accident where extract(year from accident_date)=2022 group by month;
-- Select case 
--  when extract(month from accident_date) in '1' then 'january'
--  when extract(month from accident_date) in '2' then 'February'
--  when extract(month from accident_date) in '3' then 'March'
--  when extract(month from accident_date) in '4' then 'April'
--  when extract(month from accident_date) in '5' then 'May'
--  when extract(month from accident_date) in '6' then 'June'
--  when extract(month from accident_date) in '7' then 'July'
--  when extract(month from accident_date) in '8' then 'August'
--  when extract(month from accident_date) in '9' then 'September'
--  when extract(month from accident_date) in '10' then 'October'
--  when extract(month from accident_date) in '11' then 'November'
--  when extract(month from accident_date) in '12' then 'December'
--  else 'No month'
--  end as month_of_year ,sum(number_of_casualties) from road_accident group by (
-- case 
--  when extract(month from accident_date) in '1' then 'january'
--  when extract(month from accident_date) in '2' then 'February'
--  when extract(month from accident_date) in '3' then 'March'
--  when extract(month from accident_date) in '4' then 'April'
--  when extract(month from accident_date) in '5' then 'May'
--  when extract(month from accident_date) in '6' then 'June'
--  when extract(month from accident_date) in '7' then 'July'
--  when extract(month from accident_date) in '8' then 'August'
--  when extract(month from accident_date) in '9' then 'September'
--  when extract(month from accident_date) in '10' then 'October'
--  when extract(month from accident_date) in '11' then 'November'
--  when extract(month from accident_date) in '12' then 'December'
--  else 'No month'
--  end

Select
	case	
		when extract(month from accident_date) = '1' then 'January'
		when extract(month from accident_date) = '2' then 'February'
		 when extract(month from accident_date) = '3' then 'March'
		 when extract(month from accident_date) = '4' then 'April'
		 when extract(month from accident_date) = '5' then 'May'
		 when extract(month from accident_date) = '6' then 'June'
		 when extract(month from accident_date) = '7' then 'July'
		 when extract(month from accident_date) = '8' then 'August'
		 when extract(month from accident_date) = '9' then 'September'
		 when extract(month from accident_date) = '10' then 'October'
		 when extract(month from accident_date) = '11' then 'November'
		 when extract(month from accident_date) = '12' then 'December'
		end as month_name , sum(number_of_casualties) from road_accident
		where extract(year from accident_date) = 2022 group by 
		(
		case	
		when extract(month from accident_date) = '1' then 'January'
			when extract(month from accident_date) = '2' then 'February'
			 when extract(month from accident_date) = '3' then 'March'
			 when extract(month from accident_date) = '4' then 'April'
			 when extract(month from accident_date) = '5' then 'May'
			 when extract(month from accident_date) = '6' then 'June'
			 when extract(month from accident_date) = '7' then 'July'
			 when extract(month from accident_date) = '8' then 'August'
			 when extract(month from accident_date) = '9' then 'September'
			 when extract(month from accident_date) = '10' then 'October'
			 when extract(month from accident_date) = '11' then 'November'
			 when extract(month from accident_date) = '12' then 'December'
		end) order by sum(number_of_casualties) asc;




 
