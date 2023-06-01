# Covid-19-Project
A Covid-19 project highliting key trends upto 2023

A project that involves analyzing COVID-19 data using Excel, Mysql, BigQuery and Tableau. The project utilizes the latest covid_19 dataset obtained from Our World in Data (https://ourworldindata.org/explorers/coronavirus-data-explorer?zoomToSelection=true&time=2020-02-13..2023-05-27&facet=none&country=USA~GBR~CAN~DEU~ITA~IND&pickerSort=asc&pickerMetric=location&Metric=Confirmed+cases&Interval=7-day+rolling+average&Relative+to+Population=true&Color+by+test+positivity=false).

The queries perform various analyses on the COVID-19 data, including calculating total cases, total deaths, and death percentages for different countries and locations. They also examine the impact of COVID-19 on population by calculating cases percentages and identifying countries with the highest infection rates compared to their population.

Additionally, the queries explore global statistics, such as total new cases and new deaths recorded across the globe. They also investigate COVID-19 vaccinations by joining the covid_deaths and covid_vaccinations tables and calculating the rolling total of new vaccinations, vaccination percentages, and population coverage.

The project includes the use of Common Table Expressions (CTEs) and temporary tables to perform calculations and store intermediate results. Finally, a view named PercentPopulationVaccinated is created to store data for future visualizations.

Overall, the project aims to provide insights into COVID-19 trends, the impact on different locations, and the progress of vaccination efforts. These queries can serve as a starting point for further analysis and visualization of the COVID-19 data in BigQuery.
