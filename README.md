# Global CO2 Emissions
This entails the analysis of a dataset containing global fossil fuel emissions data from 1750 to 2021.

---

> [Introduction](https://github.com/Afokoghene/Global-CO2-Emissions/#introduction) <br>
> [Problem Statement](https://github.com/Afokoghene/Global-CO2-Emissions/#problem-statement) <br>
> [Skills Demonstrated](https://github.com/Afokoghene/Global-CO2-Emissions/#skills-demonstrated) <br>
> [Data Sourcing](https://github.com/Afokoghene/Global-CO2-Emissions/#data-sourcing) <br>
> [Data Assessment and Transformation](https://github.com/Afokoghene/Global-CO2-Emissions/#data-assessment-and-transformation) <br>
> [Data Analysis and Insights](https://github.com/Afokoghene/Global-CO2-Emissions/#data-analysis-and-insights) <br>

---

## Introduction

  Analysis of the Global CO2 Emissions dataset shows a comprehensive record of CO2 emissions dating back to approximately 1750, although with some gaps in data entry. This historical documentation shows humanity's early engagement in CO2 emissions and highlights the enduring impact of our activities on the ecosystem.

  This study aims to delve into our emission patterns, addressing key inquiries to enhance our understanding of emission trends. Specifically, it seeks to identify the primary contributors to global CO2 emissions geographically and pinpoint regions where the average individual emits the highest levels of CO2. By examining these facets, we aim to glean valuable insights into our emission dynamics and their implications for environmental sustainability.

---

## Problem Statement

The problem statement for this analysis are simply the preset questions that cae alongside the dataset and we will aim to answer them.
Below are the questions

1. How have global emissions of carbon dioxide (CO2) changed over time?
2. Who emits the most CO2 each year?
3. Where in the world does the average person emit the most carbon dioxide (CO2) each year?
4. How have global emissions of carbon dioxide (CO2) from fossil fuels and land use changed over time?

---

## Skills Demonstrated
- Transformation of data using MS SQL Server
- Analysis of data on MS SQL Server using sub-queries and aggregate functions

---

## Data Sourcing
The dataset was obtained from [Maven Analytics'](https://mavenanalytics.io/data-playground) website where datasets are generally available for practice purposes.

---

## Data Assessment and Transformation
### Assessment
- Upon download of the dataset, it was opened with MS Excel and assessed before saving and importing to MS SQL Server for transformation and analysis.
- The dataset contains 79 columns and 50,598 rows. As the columns are thatmuch, I will be selecting the important colums/the ones important to this analysis and adding the type of information they hold. The data dictionary is attached to this repository and it contains all other columsn I will not  be explaining.

1. year: Year of observation
2. country: Geographic location
3. co2: Annual total emissions of carbon dioxide (CO2), excluding land-use change, measured in million tonnes
4. co2_including_luc: Annual total emissions of carbon dioxide (CO2), including land-use change, measured in million tonnes
5. co2_growth_abs: Annual growth in total emissions of carbon dioxide (CO2), excluding land-use change, measured in million tonnes
6. co2_including_luc_growth_abs: Annual growth in total emissions of carbon dioxide (CO2), including land-use change, measured in million tonnes
7. co2_per_capita: Annual CO2 emissions (per capita) - Annual total emissions of carbon dioxide (CO2), excluding land-use change, measured in tonnes per person

### Transformation
Much transformation was not needed on the dataset as everything was in the right order and columns were in the right data types. 
- The single transformation made was to remove all rows that had NULL values in the country column as we were working mainly with country column and any NULL value wont be of use.

### Observations
- It was noticed that in the 'country' column, there were values such as Africa, South America, Europe, Asia, etc. These values do not represent countries and so are not supposed to be in that column. So, to exclude them without deleting, they were excluded in the 'WHERE' clause of the query anytime the 'country' column is to be used.
- It was also noticed that some years in the dataset have NULL values in the CO2, co2_including_luc, co2_growth_abs, and co2_including_luc_growth_abs, all of which are important in the analysis. To avoid NULLs affecting the analysis, years that do have NULLs in any of those columns were excluded using the 'WHERE' clause in the query for when the analysis related to those columns.

---

## Data Analysis and Insights

This section of the documentation will mainly cover the queries used to answer each question. The results from the queries were long, so they will not be displayed alongside the query. Instead, a brief explanation of the query and the insights drawn to answer each question will follow the query.

---

- Question 1: How have global emissions of carbon dioxide (CO2) changed over time?

```sql
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
```

To answer this question, the average for fields directly relating to CO2 emissions were gotten and grouped by and ordered by year as it is with the year we will see the trends and see if there was an increase or decrease.

NULLS were found for most of the fields from the 17th century to the early 18th century. So to take care of that, all NULL values for the fields we are interested in were filtered out for the fields we are interested in using the 'WHERE' clause.

After the analysis and visualization to notice trends, the following insights were drawn to answer the question.

- Overall CO2 Emission: Both average CO2 and average CO2_Including_LUC consistently increased over the years and to date. This indicates a general trend of increasing emissions globally.
- Growth Rates: The average CO2_Growth_ABS and average CO2_Including_LUC_Growth_ABS fluctuated over time with no significant increases or decreases. Positive values indicate increases, while negative values indicate lower emissions for that year compared to the previous year. These fluctuations could be influenced by various factors such as economic conditions, technological advancements, policy changes, and natural events.
- Impact of Land-Use Change: Comparing average CO2 emissions to average CO2_Including_LUC, there is a significant increase in emission levels with Land-Use Change added. Land-Use changes, such as deforestation or afforestation, can contribute to CO2 emissions or absorption, respectively, and have a notable impact on the overall carbon balance.
- Patterns: It can be observed that from around 1960 to date, there was a drastic increase in CO2 emission levels looking at both average CO2 emissions and average CO2_Including_LUC. There were breaks in the spike, but they were insignificant compared to the increase in emissions. This increase in CO2 emissions can be attributed to industrialization and economic growth.
- Recent trends: In recent years, from 2019 to 2021, the average CO2 and average CO2_Including_LUC emission levels fluctuate, dipping a bit before a sudden spike again. This could be influenced by factors such as increased awareness of climate change, efforts to transition to renewable energy sources, and improvements in energy efficiency.
It can be noticed from the trends that the highest emission levels have been recorded in the 20th century, and since the beginning of the 20th century, the emission level has steadily been on the rise with little to no decrease except for the fluctuation mentioned above.

---

- Question 2: Who emits the most CO2 each year?

```sql
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
```

To answer this question, we will use the Year, Country, and CO2 columns only. To do that, we queried to find the country with the most emissions for each year and also checked for the top 5 countries with the most total CO2 emissions in the whole dataset.

While working on this, it was noticed that the Country column held values such as World, Europe, Africa (GCP) etc. Time was then taken to filter out all values that were not countries, even though they represented a geographical region since we only want to work with countries at this moment.

- Looking into the 'Who emits the most CO2 by year,' it is noticed that the United Kingdom emitted the most CO2 from 1851 to 1887. That is to say, the United Kingdom emitted the most CO2 for 37 consecutive years.
- The United States emitted the most CO2 in 1888, but the United Kingdom swooped in to emit the most again in 1889, just before the United States took the lead to emit the most CO2 from 1890 to 2005. The United States emitted the most CO2 for 115 consecutive years. This position of emitting the most CO2 for a century and 15 years can be said to be influenced by industrialization and advancement in technology by the United States.
- China emerged as the leader in CO2 emissions from 2006 to 2021, maintaining the top position for 16 consecutive years. This significant volume of emissions from China can also be attributed to technological advancements and industrialization.
- For the 37 years that the United Kingdom emitted the most CO2, it is noticed that the total amount of CO2 it emitted is 8,613.53 million tonnes. The United States emitted a total of 329,694.065 million tonnes of CO2 in its 115 years run as top CO2 emitting country. China is seen to have emitted 149,896.644 million tonnes in its 16 years of being the top most emitter of CO2 globally.

- It can be seen that the United Kingdom had a lesser CO2 emission level in its 37 years of being the top-most emitter compared to China, which emitted almost 18 times what the United Kingdom emitted in a space of 16 years. This can be attributed to the fact that China emitted the most CO2 in the 20th century, and industrialization was already at its peak during that period. The use of fossil fuels had become deeply entrenched in society, construction, and many other activities that contributed to the increased rate of CO2 emissions. On the other hand, the United Kingdom can be seen to top the CO2 emission list at the very beginning of industrialization, and not much emission had been occurring at that time. The United States is seen to bridge the gap between early industrialization and early-peak industrialization, as it emitted the most from 1890 to 2005 (the late 18th century to early 20th century).

---
- In descending order, below are the top 5 countries with the most total CO2 emissions and the amount of CO2 they emitted (this shows the country that emitted the most CO2 in the whole dataset)

| S/N | Country | Total CO2 Emitted (Million Tonnes) |
|---------------|------|---------------|
| 1             | United States | 421,716.882             |
| 2             | China | 249,352.817             |
| 3             | Russia | 117,547.013             |
| 4             | Germany | 93,035.852            |
| 5             | United Kingdom | 74,805.396            |

---

- Question 3: Where in the world does the average person emit the most carbon dioxide (CO2) each year?

To answer this question, the Year, Country and CO2_Per_Capita columns were used. The average of CO2 emissions per capita for each country by year was first calculated and the country with the highest average CO2 emissions per capita for each year selected.

```sql
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
```

From the results, the following was observed:

- The United Kingdom had the highest average CO2 emissions per capita for 52 consecutive years, starting from 1851 to 1902, with a maximum average of 10.215 tonnes per person in 1900.
- The United States picked up by having the highest CO2 emissions per capita from 1903 to 1935 which is a span of 33 years. It had a maximum average of 17.478 tonnes per person in 1923.
- From 1950 to 1984, Sint Maarten (Dutch part) was seen to be consistent by having the highest CO2 emissions per capita with a maximum average of 824.457 tonnes per person in 1954.
- The United Arab Emirates (UAE) snuck in to have the highest CO2 emissions per capita with 30.11 tonnes per person in 1987.
- From 1992 to 2014 (period of 23 years), Qatar took the run and stayed consistent by having the highest CO2 emissions per capita with a maximum average of 62.259 tonnes per person for the period.
- Curacao had the highest CO2 emissions per capita in 2015 and 2016 just before Qatar took over and had the highest from 2017 to 2021.


Summary: It seems that the United Kingdom had the highest average CO2 emissions per capita in the early years, but later on, countries like the United States and Qatar emerged with significantly higher emissions per capita, especially in more recent years. This suggests a shift in emissions patterns over time, likely influenced by factors such as industrialization, economic growth, and energy consumption. It also indicates that while historically developed countries like the UK had high emissions per capita in the past, newer economic powers like Qatar have surpassed them in recent years.

---

- Question 4: How have global emissions of carbon dioxide (CO2) from fossil fuels and land use changed over time?

```sql
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
```

From the results of the above query, the following insights were drawm:

- Trends in CO2 Emissions: The total CO2 emissions have been increasing over time, with fluctuations observed in some years. This indicates a general trend of rising carbon emissions globally, which is concerning for climate change mitigation efforts.
- Effect of Land Use Change: The total CO2 emissions including land use change (total_co2_including_luc) and the growth in emissions including land use change (total_co2_including_luc_growth_abs) show varying patterns. Land use change appears to have contributed both positively and negatively to total emissions in different years.
- Yearly Variations: There are significant fluctuations in CO2 emissions and growth absolute values from year to year. These variations could be influenced by factors such as economic activities, technological advancements, policy changes, and natural events.
- Recent Trends: In recent years, there seems to be an increasing trend in total CO2 emissions and growth, indicating a pressing need for more effective climate change mitigation strategies.
- Negative Growth: In some years, there are negative values for total CO2 growth absolute (total_co2_growth_abs) and total CO2 growth absolute including land use change (total_co2_including_luc_growth_abs), suggesting a reduction in emissions compared to the previous year. This could be due to various factors such as changes in energy consumption, industrial activities, or environmental policies.

---

Thank you for reading, I appreciate your patience.
You can reach out to me for collaborations or jobs on [X](https://twitter.com/__afoke?t=_YX2DAel3R3aWZGDvSEZ9w&s=09), [LinkedIn](https://www.linkedin.com/in/afokoghene-osiobe-arierhi-9b235b25b) or send me an [email](afokeosiobe@gmail.com).








































