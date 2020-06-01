DROP TABLE IF EXISTS ratinglang;
CREATE TEMPORARY TABLE ratinglang
	SELECT ratings.id AS id, ratings.rating, ratings.user_id AS user_id, movies.id AS movie, movies.title, languages.name AS lang FROM ratings INNER JOIN movies ON movies.id=ratings.movie INNER JOIN languages ON movies.original_language=languages.id;

-- How many languauges has user rated movies on?
SELECT user_id, count(DISTINCT lang) FROM ratinglang GROUP BY user_id;
