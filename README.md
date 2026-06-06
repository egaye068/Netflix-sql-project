# Netflix-sql-project

# Netflix Movies and TV Shows Data Analysis using SQL
<img width="2226" height="678" alt="logo" src="https://github.com/user-attachments/assets/cd7c68da-257d-4aa3-bd1c-31072dbdf335" />

## Overview 
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives 
- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

### Schema 
```sql
CREATE TABLE netflix (
		show_id	VARCHAR (20),
		type_1	VARCHAR (20),
		title	VARCHAR (200),
		director	VARCHAR (500),
		cast_1	VARCHAR (1000),
		country	 VARCHAR (200),
		date_added	VARCHAR (50),
		release_year	INT,
		rating	VARCHAR (20),
		duration	VARCHAR (20),
		listed_in	VARCHAR (200),
		description VARCHAR (500)
);
```
