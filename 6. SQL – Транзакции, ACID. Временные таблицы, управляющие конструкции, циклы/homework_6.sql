/* 1. Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, с 
помощью которой можно переместить любого (одного) пользователя из таблицы 
users в таблицу users_old. (использование транзакции с выбором commit или rollback
– обязательно). */
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id INT AUTO_INCREMENT PRIMARY KEY, 
    firstname VARCHAR(50), 
    lastname VARCHAR(50), 
    email VARCHAR(50)
);
DELIMITER //
DROP PROCEDURE IF EXISTS move_user_to_old;
CREATE PROCEDURE move_user_to_old (
	IN user_id INT
)
	DETERMINISTIC
BEGIN
	INSERT INTO users_old (firstname, lastname, email)
    SELECT firstname, lastname, email
    FROM lesson_4.users
    WHERE id = user_id;
    DELETE FROM lesson_4.users WHERE id = user_id;
    COMMIT;
END//
DELIMITER ;

CALL move_user_to_old(8);

/* 2. Создайте хранимую функцию hello(), которая будет возвращать приветствие, в 
зависимости от текущего времени суток. С 6:00 до 12:00 функция должна 
возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать 
фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй 
ночи". */
DELIMITER //
DROP FUNCTION IF EXISTS hello;
CREATE FUNCTION hello()
	RETURNS VARCHAR(25)
    DETERMINISTIC
BEGIN
	DECLARE result_text VARCHAR(25);
    DECLARE local_time TIME;
    SET local_time = CONVERT_TZ(CURRENT_TIME(), '+00:00', '+03:00');
    
    SELECT CASE
		WHEN local_time BETWEEN '12:00:00' AND '18:00:00' THEN 'Добрый день'
		WHEN local_time BETWEEN '06:00:00' AND '12:00:00' THEN 'Доброе утро'
		WHEN local_time BETWEEN '00:00:00' AND '06:00:00' THEN 'Доброй ночи'
		ELSE 'Добрый вечер'
		END 
	INTO result_text;
    RETURN result_text;
END //
DELIMITER ;

SELECT hello() AS Message, CONVERT_TZ(CURRENT_TIME(), '+00:00', '+03:00') AS Time;

/* 3. (по желанию)* Создайте таблицу logs типа Archive. Пусть при каждом создании 
записи в таблицах users, communities и messages в таблицу logs помещается время и 
дата создания записи, название таблицы, идентификатор первичного ключа. */
CREATE TABLE logs (
  datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  table_name VARCHAR(50),
  primary_key INT(11)
) ENGINE=ARCHIVE;

USE lesson_4;
DELIMITER //
CREATE TRIGGER log_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, primary_key) VALUES ('users', NEW.id);
END;

CREATE TRIGGER log_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, primary_key) VALUES ('communities', NEW.id);
END;

CREATE TRIGGER log_messages AFTER INSERT ON messages
FOR EACH ROW
BEGIN
  INSERT INTO logs (table_name, primary_key) VALUES ('messages', NEW.id);
END;
DELIMITER ;

INSERT INTO lesson_4.users (firstname, lastname, email) 
	VALUES ('John', 'Wick', 'chuca@example.tw');