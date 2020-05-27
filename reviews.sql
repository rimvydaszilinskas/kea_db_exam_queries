-- Show all reviews including the user
SELECT 
    ratings.id AS rating_id, movies.id AS movie_id, movies.title, ratings.rating, ratings.review, users.first_name, users.last_name, users.id AS user_id 
    FROM ratings 
    INNER JOIN users 
        ON users.id=ratings.user_id 
    INNER JOIN movies 
        ON movies.id=ratings.movie;