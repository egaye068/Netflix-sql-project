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

### Database 
Create database named netflix_d1 
```sql
CREATE DATABASE netflix_d1
```

### Schema 
Create table named netflix 
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
### Business Questions and Solutions 

**Question 1:Count the Number of Movies vs TV Shows**
```sql
SELECT 
	type_1,
	COUNT(*)
FROM netflix 
GROUP BY 1;
```
**Question 2:Find the Most Common Rating for Movies and TV Shows**
```sql
WITH CTE AS (
		SELECT 
		type_1,
		rating,
		COUNT(*) as fr_rating, 
		RANK () OVER (PARTITION BY type_1 ORDER BY COUNT(*) DESC) AS rnk 
		FROM netflix 
		GROUP BY 1, 2)
SELECT 
type_1,
rating, 
fr_rating
FROM CTE 
WHERE rnk = 1;
```
**Question 3:List All Movies Released in a Specific Year (e.g., 2020)**
```sql
SELECT * 
FROM netflix 
WHERE release_year = 2020;
```
**Question 4:  Find the Top 5 Countries with the Most Content on Netflix**
```sql
WITH CTE AS (
		SELECT 
		UNNEST(STRING_TO_ARRAY(country, ',') )AS countries,
		COUNT(*) AS no_content 
		FROM netflix 
		GROUP BY 1)
SELECT * 
FROM CTE 
WHERE countries is not null 
ORDER BY no_content DESC 
LIMIT 5;
```
**Question 5:Identify the Longest Movie**
```sql
SELECT *
FROM netflix 
WHERE type_1 = 'Movie' AND duration IS NOT NULL 
ORDER BY SPLIT_PART(duration, ' ', 1) :: INT DESC
LIMIT 1;
```
**Question 6:Find Content Added in the Last 5 Years**
```sql
SELECT *
FROM netflix 
WHERE TO_DATE(date_added, 'month, DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Question 7:Find All Movies/TV Shows by Director 'Rajiv Chilaka'**
```sql
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%';
```
**Question 8: List All TV Shows with More Than 5 Seasons**
```sql
SELECT * 
FROM netflix 
WHERE type_1 = 'TV Show'
AND SPLIT_PART(duration, ' ', 1):: INT > 5;
```
**Question 9: Count the Number of Content Items in Each Genre**
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(*) AS no_content 
FROM netflix 
GROUP BY 1 
ORDER BY 2 DESC;
```
**Question 10: Find each year and the average numbers of content release in India on netflix**
```sql
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```
**Question 11:  List All Movies that are Documentaries**
```sql
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%Documentaries%';
```
**Question 12:  Find All Content Without a Director**
```sql
SELECT * 
FROM netflix 
WHERE director IS NULL;
```
**Question 13: Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years**
```sql
SELECT * 
FROM netflix 
WHERE type_1 ='Movie'
AND cast_1 ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10;
```
**Question 14: Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India**
```sql
SELECT 
	UNNEST(STRING_TO_ARRAY(cast_1, ',')) as actors,
	COUNT(*) as no_appears 
FROM netflix 
WHERE country ILIKE '%India%'
GROUP BY 1 
ORDER BY 2 DESC
lIMIT 10;
```
**Question 15: Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords**
```sql
SELECT 
CASE 
		WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'Bad'
		ELSE 'Good'
END AS category,
COUNT(*)
FROM netflix
GROUP BY 1 
ORDER  BY 2  DESC;
```
## Findings and Conclusion
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
