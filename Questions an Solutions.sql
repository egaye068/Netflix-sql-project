SELECT * FROM netflix 

/* Business questions and solutions 
*/

/* Question 1: Count the Number of Movies vs TV Shows
*/ 
SELECT 
	type_1,
	COUNT(*)
FROM netflix 
GROUP BY 1 

/* Question 2: Find the Most Common Rating for Movies and TV Shows
*/
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

/* Question 3: List All Movies Released in a Specific Year (e.g., 2020)
*/
SELECT * 
FROM netflix 
WHERE release_year = 2020;

/*Question 4:  Find the Top 5 Countries with the Most Content on Netflix
*/

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

/*Question 5:  Identify the Longest Movie
*/

SELECT *
FROM netflix 
WHERE type_1 = 'Movie' AND duration IS NOT NULL 
ORDER BY SPLIT_PART(duration, ' ', 1) :: INT DESC
LIMIT 1;

/* Question 6:  Find Content Added in the Last 5 Years
*/ 

SELECT *
FROM netflix 
WHERE TO_DATE(date_added, 'month, DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

/* Question 7: Find All Movies/TV Shows by Director 'Rajiv Chilaka'
*/
SELECT * 
FROM netflix 
WHERE director ILIKE '%Rajiv Chilaka%'

/* Question 8: List All TV Shows with More Than 5 Seasons
*/

SELECT * 
FROM netflix 
WHERE type_1 = 'TV Show'
AND SPLIT_PART(duration, ' ', 1):: INT > 5; 

/* Question 9: Count the Number of Content Items in Each Genre
*/
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')),
	COUNT(*) AS no_content 
FROM netflix 
GROUP BY 1 
ORDER BY 2 DESC 

/* Question 10: Find each year and the average numbers of content release in India on netflix.
*/

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

/* Question 11:  List All Movies that are Documentaries
*/
SELECT * 
FROM netflix 
WHERE listed_in ILIKE '%Documentaries%'

/* Question 12:  Find All Content Without a Director
*/
SELECT * 
FROM netflix 
WHERE director IS NULL 

/* Question 13: Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
*/

SELECT * 
FROM netflix 
WHERE type_1 ='Movie'
AND cast_1 ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE)-10

/* Question 14: Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
*/
SELECT 
	UNNEST(STRING_TO_ARRAY(cast_1, ',')) as actors,
	COUNT(*) as no_appears 
FROM netflix 
WHERE country ILIKE '%India%'
GROUP BY 1 
ORDER BY 2 DESC
lIMIT 10 

/* Qiuestion 15: Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
*/

SELECT 
CASE 
		WHEN description ILIKE '%Kill%' OR description ILIKE '%Violence%' THEN 'Bad'
		ELSE 'Good'
END AS category,
COUNT(*)
FROM netflix
GROUP BY 1 
ORDER  BY 2  DESC; 

