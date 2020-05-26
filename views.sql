USE film;

-- How many movies for language
DROP VIEW IF EXISTS language_movies;
CREATE VIEW language_movies
	AS SELECT languages.id, languages.name, COUNT(movies.id) as movies FROM languages LEFT JOIN movies ON movies.original_language=languages.id GROUP BY languages.id;
    
SELECT * FROM language_movies;

-- What is the rating of each movie
DROP VIEW IF EXISTS movie_ratings;
CREATE VIEW movie_ratings
	AS SELECT movies.id, movies.title, AVG(ratings.rating) FROM movies INNER JOIN ratings ON movies.id=ratings.movie GROUP BY movies.id;
    
SELECT * FROM movie_ratings;

DROP VIEW IF EXISTS directors;
CREATE VIEW directors AS
	SELECT celebrities.*, COUNT(directed.movie) AS movie_count 
		FROM celebrities RIGHT JOIN directed ON directed.celebrity=celebrities.id GROUP BY celebrities.id;

SELECT * FROM directors;

DROP VIEW IF EXISTS actors;
CREATE VIEW actors AS
	SELECT celebrities.*, COUNT(acted.movie) AS movie_count 
		FROM celebrities RIGHT JOIN acted ON acted.celebrity=celebrities.id GROUP BY celebrities.id;
        
SELECT * FROM actors;
