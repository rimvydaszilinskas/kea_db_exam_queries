USE film;

DELIMITER $$
DROP FUNCTION IF EXISTS MostPopularLanguage$$

CREATE FUNCTION MostPopularLanguage()
RETURNS VARCHAR(20)
BEGIN
	DECLARE LANG VARCHAR(20) DEFAULT '';

    SELECT languages.name INTO LANG 
		FROM languages 
        INNER JOIN movies ON movies.original_language=languages.id 
        GROUP BY languages.id DESC
        ORDER BY COUNT(movies.id)
        LIMIT 1;
    
    RETURN LANG;
END$$

DROP FUNCTION IF EXISTS LeastPopularLanguage$$

CREATE FUNCTION LeastPopularLanguage()
RETURNS VARCHAR(20)
BEGIN
	DECLARE LANG VARCHAR(20) DEFAULT '';
    
    SELECT languages.name INTO LANG 
		FROM languages 
        INNER JOIN movies ON movies.original_language=languages.id 
        GROUP BY languages.id ASC
        ORDER BY COUNT(movies.id)
        LIMIT 1;
    
    RETURN LANG;
END$$

DELIMITER ;

SELECT LeastPopularLanguage(), MostPopularLanguage();