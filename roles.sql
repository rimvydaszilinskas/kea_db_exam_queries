DROP USER IF EXISTS 'producer'@'localhost';
CREATE USER 'producer'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT ON film.rating_at_time TO 'producer'@'localhost';
GRANT ALL ON film.movies TO 'producer'@'localhost';
GRANT ALL ON film.movie_categories TO 'producer'@'localhost';
GRANT SELECT ON film.languages TO 'producer'@'localhost';
GRANT SELECT ON film.categories TO 'producer'@'localhost';
GRANT SELECT, INSERT, UPDATE ON film.celebrities TO 'producer'@'localhost';
GRANT ALL ON film.directed TO 'producer'@'localhost';
GRANT ALL ON film.acted TO 'producer'@'localhost';

DROP USER IF EXISTS 'user'@'localhost';
CREATE USER 'user'@'localhost' IDENTIFIED BY 'password';

GRANT SELECT, INSERT, UPDATE ON film.ratings TO 'user'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON film.users TO 'user'@'localhost';


GRANT SELECT ON film.language_movies TO 'user'@'localhost';
GRANT SELECT ON film.language_movies TO 'producer'@'localhost';
GRANT SELECT ON film.movie_ratings TO 'user'@'localhost';
GRANT SELECT ON film.movie_ratings TO 'producer'@'localhost';
GRANT SELECT ON film.directors TO 'user'@'localhost';
GRANT SELECT ON film.directors TO 'producer'@'localhost';
GRANT SELECT ON film.actors TO 'user'@'localhost';
GRANT SELECT ON film.actors TO 'producer'@'localhost';
