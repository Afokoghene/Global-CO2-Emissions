CREATE DATABASE GCO2E

USE GCO2E
EXEC sp_help 'GCO2E.dbo.GlobalCO2Emissions'


SELECT *
FROM GCO2E.dbo.GlobalCO2Emissions
ORDER BY Country


DELETE FROM GCO2E.dbo.GlobalCO2Emissions
WHERE Country IS NULL;


SELECT *
FROM GCO2E.dbo.GlobalCO2Emissions
WHERE LEN(iso_code) > 3


----------------------------------------------------------------------------------------------------------------
--- How have global emissions of carbon dioxide (CO2) changed over time?

SELECT *
FROM GCO2E.dbo.GlobalCO2Emissions
ORDER BY Country


SELECT year,
	   co2,
	   co2_including_luc,
       co2_growth_abs,
       co2_including_luc_growth_abs
FROM GCO2E.dbo.GlobalCO2Emissions
ORDER BY year

-- Using the above query, I noticed that there were so many NULL values from the year 1750 til the 19s. So I will filter for 
-- years that do not have NULLS in any of the fields that will be pulled up

SELECT 
    year,
    co2,
    co2_including_luc,
    co2_growth_abs,
    co2_including_luc_growth_abs
FROM 
    GCO2E.dbo.GlobalCO2Emissions
WHERE 
    co2 IS NOT NULL 
    AND co2_including_luc IS NOT NULL 
    AND co2_growth_abs IS NOT NULL 
    AND co2_including_luc_growth_abs IS NOT NULL
ORDER BY 
    year;


-- The query below calculates the average for all CO2 related fields grouped by year to see the change/trends 
-- in co2 emissions over time 
--    --> This answers the question "How have global emissions of carbon dioxide (CO2) changed over time?"

SELECT year,
	   ROUND(AVG(co2), 3) avg_co2,
	   ROUND(AVG(co2_including_luc), 3) avg_co2_including_luc,
	   ROUND(AVG(co2_growth_abs), 3) avg_co2_growth_abs,
	   ROUND(AVG(co2_including_luc_growth_abs), 3) avg_co2_including_luc_growth_abs
FROM 
       GCO2E.dbo.GlobalCO2Emissions
WHERE 
       co2 IS NOT NULL 
       AND co2_including_luc IS NOT NULL 
       AND co2_growth_abs IS NOT NULL 
       AND co2_including_luc_growth_abs IS NOT NULL
GROUP BY 
	   year
ORDER BY 
	   year


----------------------------------------------------------------------------------------------------------------
--- Who emits the most CO2 each year?

SELECT year, country, max_co2_emission
FROM (
    SELECT 
        year, 
        country, 
        co2 AS max_co2_emission,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY co2 DESC) AS rn
    FROM 
        GCO2E.dbo.GlobalCO2Emissions
    WHERE 
        co2 IS NOT NULL 
        AND co2_including_luc IS NOT NULL 
        AND co2_growth_abs IS NOT NULL 
        AND co2_including_luc_growth_abs IS NOT NULL
        AND Country NOT IN ('Africa', 'Africa (GCP)', 'Asia (excl. China and India)', 'Asia', 
							'Asia (GCP)', 'Central America (GCP)', 'Europe', 'Europe (excl. EU-27)', 
							'Europe (excl. EU-28)', 'Europe (GCP)', 'European Union (27)', 
							'European Union (27) (GCP)', 'European Union (28)', 'French Equatorial Africa (GCP)',
							'French Equatorial Africa (Jones et al. 2023)', 'French Guiana', 'French Polynesia', 
							'French West Africa (GCP)', 'French West Africa (Jones et al. 2023)', 
							'High-income countries', 'International transport', 'Kuwaiti Oil Fires (GCP)', 
							'Kuwaiti Oil Fires (Jones et al. 2023)', 'Least developed countries (Jones et al. 2023)',
							'Leeward Islands (GCP)', 'Leeward Islands (Jones et al. 2023)', 'Lower-middle-income countries', 
							'Low-income countries', 'Middle East (GCP)', 'Non-OECD (GCP)', 'North America', 
							'North America (excl. USA)', 'North America (GCP)', 'Netherlands Antilles', 
							'Oceania (GCP)', 'OECD (GCP)', 'OECD (Jones et al. 2023)', 
							'Panama Canal Zone (Jones et al. 2023)', 'Panama Canal Zone (GCP)', 
							'Ryukyu Islands (GCP)', 'Ryukyu Islands (Jones et al. 2023)', 'South America', 
							'South America (GCP)', 'St. Kitts-Nevis-Anguilla (GCP)', 
							'St. Kitts-Nevis-Anguilla (Jones et al. 2023)', 'Upper-middle-income countries', 'World', 'Oceania')
) AS ranked
WHERE rn = 1
ORDER BY year;


SELECT country, sum(co2) total_co2_emission
FROM GCO2E.dbo.GlobalCO2Emissions
WHERE 
        co2 IS NOT NULL 
        AND co2_including_luc IS NOT NULL 
        AND co2_growth_abs IS NOT NULL 
        AND co2_including_luc_growth_abs IS NOT NULL
        AND Country NOT IN ('Africa', 'Africa (GCP)', 'Asia (excl. China and India)', 'Asia', 
							'Asia (GCP)', 'Central America (GCP)', 'Europe', 'Europe (excl. EU-27)', 
							'Europe (excl. EU-28)', 'Europe (GCP)', 'European Union (27)', 
							'European Union (27) (GCP)', 'European Union (28)', 'French Equatorial Africa (GCP)',
							'French Equatorial Africa (Jones et al. 2023)', 'French Guiana', 'French Polynesia', 
							'French West Africa (GCP)', 'French West Africa (Jones et al. 2023)', 
							'High-income countries', 'International transport', 'Kuwaiti Oil Fires (GCP)', 
							'Kuwaiti Oil Fires (Jones et al. 2023)', 'Least developed countries (Jones et al. 2023)',
							'Leeward Islands (GCP)', 'Leeward Islands (Jones et al. 2023)', 'Lower-middle-income countries', 
							'Low-income countries', 'Middle East (GCP)', 'Non-OECD (GCP)', 'North America', 
							'North America (excl. USA)', 'North America (GCP)', 'Netherlands Antilles', 
							'Oceania (GCP)', 'OECD (GCP)', 'OECD (Jones et al. 2023)', 
							'Panama Canal Zone (Jones et al. 2023)', 'Panama Canal Zone (GCP)', 
							'Ryukyu Islands (GCP)', 'Ryukyu Islands (Jones et al. 2023)', 'South America', 
							'South America (GCP)', 'St. Kitts-Nevis-Anguilla (GCP)', 
							'St. Kitts-Nevis-Anguilla (Jones et al. 2023)', 'Upper-middle-income countries', 'World', 'Oceania')
GROUP BY country
ORDER BY total_co2_emission desc




WITH cte1 as (
SELECT year, country, max_co2_emission
FROM (
    SELECT 
        year, 
        country, 
        co2 AS max_co2_emission,
        ROW_NUMBER() OVER (PARTITION BY year ORDER BY co2 DESC) AS rn
    FROM 
        GCO2E.dbo.GlobalCO2Emissions
    WHERE 
        co2 IS NOT NULL 
        AND co2_including_luc IS NOT NULL 
        AND co2_growth_abs IS NOT NULL 
        AND co2_including_luc_growth_abs IS NOT NULL
        AND Country NOT IN ('Africa', 'Africa (GCP)', 'Asia (excl. China and India)', 'Asia', 
							'Asia (GCP)', 'Central America (GCP)', 'Europe', 'Europe (excl. EU-27)', 
							'Europe (excl. EU-28)', 'Europe (GCP)', 'European Union (27)', 
							'European Union (27) (GCP)', 'European Union (28)', 'French Equatorial Africa (GCP)',
							'French Equatorial Africa (Jones et al. 2023)', 'French Guiana', 'French Polynesia', 
							'French West Africa (GCP)', 'French West Africa (Jones et al. 2023)', 
							'High-income countries', 'International transport', 'Kuwaiti Oil Fires (GCP)', 
							'Kuwaiti Oil Fires (Jones et al. 2023)', 'Least developed countries (Jones et al. 2023)',
							'Leeward Islands (GCP)', 'Leeward Islands (Jones et al. 2023)', 'Lower-middle-income countries', 
							'Low-income countries', 'Middle East (GCP)', 'Non-OECD (GCP)', 'North America', 
							'North America (excl. USA)', 'North America (GCP)', 'Netherlands Antilles', 
							'Oceania (GCP)', 'OECD (GCP)', 'OECD (Jones et al. 2023)', 
							'Panama Canal Zone (Jones et al. 2023)', 'Panama Canal Zone (GCP)', 
							'Ryukyu Islands (GCP)', 'Ryukyu Islands (Jones et al. 2023)', 'South America', 
							'South America (GCP)', 'St. Kitts-Nevis-Anguilla (GCP)', 
							'St. Kitts-Nevis-Anguilla (Jones et al. 2023)', 'Upper-middle-income countries', 'World', 'Oceania')
) AS ranked
WHERE rn = 1)

SELECT country, sum(max_co2_emission) total_co2_emissions
FROM cte1
GROUP BY country
ORDER BY total_co2_emissions desc


----------------------------------------------------------------------------------------------------------------

--- Where in the world does the average person emit the most carbon dioxide (CO2) each year?

SELECT	year,
		country,
		avg_co2_per_capita
FROM 
			(SELECT	year,
					country,
					avg(co2_per_capita) avg_co2_per_capita,
					ROW_NUMBER() OVER(Partition By Year Order By avg(co2_per_capita) desc) as rn
			FROM 
					GCO2E.dbo.GlobalCO2Emissions
			WHERE	co2_per_capita IS NOT NULL
					AND co2 IS NOT NULL 
					AND co2_including_luc IS NOT NULL 
					AND co2_growth_abs IS NOT NULL 
					AND co2_including_luc_growth_abs IS NOT NULL
					AND Country NOT IN ('Africa', 'Africa (GCP)', 'Asia (excl. China and India)', 'Asia', 
										'Asia (GCP)', 'Central America (GCP)', 'Europe', 'Europe (excl. EU-27)', 
										'Europe (excl. EU-28)', 'Europe (GCP)', 'European Union (27)', 
										'European Union (27) (GCP)', 'European Union (28)', 'French Equatorial Africa (GCP)',
										'French Equatorial Africa (Jones et al. 2023)', 'French Guiana', 'French Polynesia', 
										'French West Africa (GCP)', 'French West Africa (Jones et al. 2023)', 
										'High-income countries', 'International transport', 'Kuwaiti Oil Fires (GCP)', 
										'Kuwaiti Oil Fires (Jones et al. 2023)', 'Least developed countries (Jones et al. 2023)',
										'Leeward Islands (GCP)', 'Leeward Islands (Jones et al. 2023)', 'Lower-middle-income countries', 
										'Low-income countries', 'Middle East (GCP)', 'Non-OECD (GCP)', 'North America', 
										'North America (excl. USA)', 'North America (GCP)', 'Netherlands Antilles', 
										'Oceania (GCP)', 'OECD (GCP)', 'OECD (Jones et al. 2023)', 
										'Panama Canal Zone (Jones et al. 2023)', 'Panama Canal Zone (GCP)', 
										'Ryukyu Islands (GCP)', 'Ryukyu Islands (Jones et al. 2023)', 'South America', 
										'South America (GCP)', 'St. Kitts-Nevis-Anguilla (GCP)', 
										'St. Kitts-Nevis-Anguilla (Jones et al. 2023)', 'Upper-middle-income countries', 'World', 'Oceania')
			GROUP BY year, country) ranked
WHERE rn = 1
ORDER BY year



----------------------------------------------------------------------------------------------------------------
--- How have global emissions of carbon dioxide (CO2) from fossil fuels and land use changed over time?

SELECT year,
	   SUM(co2) total_co2,
	   SUM(co2_growth_abs) total_co2_growth_abs,
	   SUM(co2_including_luc) total_co2_including_luc,
	   SUM(co2_including_luc_growth_abs) total_co2_including_luc_growth_abs
FROM GCO2E.dbo.GlobalCO2Emissions
WHERE   co2_growth_abs IS NOT NULL 
        AND co2_including_luc_growth_abs IS NOT NULL
		AND year IS NOT NULL
GROUP BY year
ORDER BY year































































