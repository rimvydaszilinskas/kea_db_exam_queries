DROP DATABASE IF EXISTS film;
CREATE DATABASE film;
USE film;

CREATE TABLE languages (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) UNIQUE
);

CREATE TABLE movies (
	id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    release_date INT NOT NULL,
    duration INT NOT NULL,
    original_language INT NULL,
    description TEXT NULL,
    
    FOREIGN KEY (original_language) REFERENCES languages(id) ON DELETE SET NULL
);

CREATE TABLE categories (
	id INT AUTO_INCREMENT PRIMARY KEY,
	title VARCHAR(100) NOT NULL
);

CREATE TABLE movie_categories (
	category INT NOT NULL,
    movie INT NOT NULL,
    
    FOREIGN KEY (movie) REFERENCES movies(id) ON DELETE CASCADE,
    FOREIGN KEY (category) REFERENCES categories(id) ON DELETE CASCADE
);

CREATE TABLE celebrities (
	id INT AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL
);

CREATE TABLE directed (
	celebrity INT NOT NULL,
    movie INT NOT NULL,
    
    FOREIGN KEY (celebrity) REFERENCES celebrities(id) ON DELETE CASCADE,
    FOREIGN KEY (movie) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE acted (
	celebrity INT NOT NULL,
    movie INT NOT NULL,
    
    FOREIGN KEY (celebrity) REFERENCES celebrities(id) ON DELETE CASCADE,
    FOREIGN KEY (movie) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE users (
	id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL
);

CREATE TABLE ratings (
	id INT AUTO_INCREMENT PRIMARY KEY,
	user_id INT NOT NULL,
    movie INT NOT NULL,
    rating TINYINT UNSIGNED NOT NULL,
    review VARCHAR(255) NULL,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (movie) REFERENCES movies(id) ON DELETE CASCADE
);

CREATE TABLE rating_at_time(
	id INT AUTO_INCREMENT PRIMARY KEY,
    movie INT NOT NULL,
    rating FLOAT NOT NULL,
    date DATE NOT NULL,
    
    FOREIGN KEY(movie) REFERENCES movies(id) ON DELETE CASCADE
);

DELIMITER $$
CREATE TRIGGER check_ratings
BEFORE INSERT
ON ratings FOR EACH ROW
BEGIN
	IF new.rating <= 0 OR new.rating>10 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Rating has to be between 1 and 10';
	END IF;
END $$

CREATE TRIGGER check_ratings_u
BEFORE UPDATE
ON ratings FOR EACH ROW
BEGIN
	IF new.rating <= 0 OR new.rating>10 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Rating has to be between 1 and 10';
	END IF;
END $$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER movie_length
BEFORE INSERT
ON movies FOR EACH ROW
BEGIN
	IF new.duration <= 0 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'No movies take you back to past';
	END IF;
END $$

CREATE TRIGGER movie_year
BEFORE UPDATE
ON movies FOR EACH ROW
BEGIN
	IF new.release_date < 1888 THEN
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = 'Movies only came after 1888!';
	END IF;
END $$

DELIMITER ;

ALTER TABLE rating_at_time ADD UNIQUE unique_date (date, movie);
ALTER TABLE ratings ADD UNIQUE unique_rating(user_id, movie);
ALTER TABLE acted ADD UNIQUE unique_actor(celebrity, movie);
ALTER TABLE directed ADD UNIQUE unique_director(celebrity, movie);
ALTER TABLE movie_categories ADD UNIQUE unique_movie_category(movie, category);

CREATE UNIQUE INDEX MOVIE_INDEX ON movies(title);

INSERT INTO languages (id, name) VALUES (1, 'English'), (2, 'German'), (3, 'Lithuanian');

INSERT INTO movies (id, title, release_date, duration, original_language, description)
VALUES 
	(1, 'The Shawshank Redemption', 1995, 144, 1, 'Andy Dufresne'),
    (2, 'Se7en', 1995, 128, 1, 'A serial killer begins murdering'),
    (3, 'Inglorious Bastards', 2009, 253, 1, 'A few Jewish soldiers..'),
    (4, 'Downfall', 2004, 256, 2, 'Nazi vs the world');
    
INSERT INTO celebrities (id, first_name, last_name, date_of_birth)
VALUES
	(1, 'Morgan', 'Freeman', '1937-06-01'),
    (2, 'Tim', 'Robbins', '1958-10-16'),
    (3, 'Brad', 'Pitt', '1963-12-18'),
    (4, 'Quentin', 'Tarantino', '1963-03-27'),
    (5, 'Bruno', 'Ganz', '1941-03-22'),
    (6, 'Oliver', 'Hirschbiegel', '1957-12-29');

INSERT INTO categories (id, title)
VALUES
	(1, 'War'),
    (2, 'Drama'),
    (3, 'Crime');
    
INSERT INTO movie_categories (category, movie)
VALUES
	(1, 3),
    (2, 3),
    (2, 2),
    (3, 2),
    (2, 1),
    (1, 4),
    (2, 4);

INSERT INTO acted (celebrity, movie) 
VALUES 
	(1, 1), 
    (2, 1), 
    (1, 2),
    (3, 2),
    (3, 3);
    
INSERT INTO directed (celebrity, movie)
VALUES
	(4, 3),
    (6, 4);

INSERT INTO users (id, first_name, last_name, email)
VALUES
	(1, 'Rimvydas', 'Zilinskas', 'rimv0016@stud.kea.dk'),
    (2, 'Test', 'Test', 'test@test.com'),
    (3, 'John', 'Doe', 'john@doe.com'),
    (4, 'Bill', 'Gates', 'bill@gates.com');

INSERT INTO ratings (id, user_id, movie, rating, review)
VALUES
	(1, 1, 1, 10, 'Veri nais'),
    (2, 2, 1, 9, null),
    (3, 2, 2, 9, 'Testing'),
    (4, 3, 2, 7, 'Seven'),
    (5, 1, 4, 8, 'Wunderbar'),
    (6, 1, 3, 8, 'Loved it');

-- SET autocommit = OFF;

CREATE EVENT collect_daily_stat
	ON SCHEDULE 
		EVERY 1 DAY 
        STARTS CURDATE() ON COMPLETION PRESERVE ENABLE
	DO
		INSERT INTO rating_at_time(movie, rating, date) 
			SELECT movies.id, AVG(ratings.rating) AS rating, CURDATE() AS DATE 
            FROM movies 
            INNER JOIN ratings 
                ON ratings.movie=movies.id 
            GROUP BY movies.id;
