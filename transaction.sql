DROP PROCEDURE IF EXISTS sp_fail;
DELIMITER $$
CREATE PROCEDURE sp_fail()
BEGIN
	DECLARE _rollback BOOL DEFAULT 0;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET _rollback=1;
    
    INSERT INTO ratings(movie, rating, user_id) VALUES(2, 9, 1);
    INSERT INTO ratings(movie, rating, user_id) VALUES(2, 8, 1);
    
    IF _rollback THEN
		ROLLBACK;
	ELSE
		COMMIT;
	END IF;
END$$
DELIMITER ;

call sp_fail();

SELECT * FROM ratings;