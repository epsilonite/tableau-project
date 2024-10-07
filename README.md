### tableau-project
# NYC citi bike
In this challenge, we are the lead analyst for the New York Citi BikeLinks, the largest bike-sharing program in the United States. Our first task is to generate regular data reports for city officials looking to publicize and improve the city program. Our first step is to implement a postgres database to transform the relevant bike data that has been collected, organized, and published by the existing robust data collection pipeline. Then we inspect and clean the data so we can implement a dashboard and sohisticated reporting process built in tableau.
## Data Engineering
**Data Exploration + Modeling:** inspecting raw data in pandas, structuring the data storage by creating databases and schemas in PostgreSQL using pgAdmin<br>
**Data Pipeline:** loading segmented CSVs into PostgreSQL, then performing data transformation (processing, cleaning, aggregating, normalizing and reshaping), using psycopg2 (a postgreSQL database adapter for python), then exporting processed tables into CSVs using pandas.
## Data Analysis:
**Data Manipulation:** loading CSV and performing data transformations in tableau<br>
**Data Visualization:** creating dynamic visualizations in tableau
## References:
"psycopg2: PostgreSQL Database Adapter for Python." PostgreSQL Global Development Group, 2024.<br>
Available at: https://www.psycopg.org/docs/

Jethro Chen. "The Radial Bar Chart in Tableau Tutorial." The Data School Australia, 2023.<br>
Available at: https://www.thedataschool.com.au/jethro-chen/the-radial-bar-chart-in-tableau-tutorial/

CitiBike NYC. "System Data." CitiBike NYC, 2023.<br>
Available at: https://citibikenyc.com/system-data

OpenAI. "ChatGPT, powered by GPT-4, for Text Editing and Code Troubleshooting." October 2024.<br>
Accessed via OpenAI platform.
