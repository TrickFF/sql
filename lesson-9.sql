/* Практическое задание по теме “Транзакции, переменные, представления” */

/* Задание 1
 * В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
 *  Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
 *  Используйте транзакции.*/

-- результат
START TRANSACTION;
INSERT INTO sample.users (name) SELECT name FROM shop.users s WHERE s.id = 1;
USE shop;
DELETE FROM users WHERE id = 1;
COMMIT;


/* Задание 2
 * Создайте представление, которое выводит название name товарной позиции из таблицы products
 *  и соответствующее название каталога name из таблицы catalogs.*/

USE shop;

-- результат
CREATE VIEW prod_name AS
SELECT p.name AS name, c.name AS category
  FROM products p
   JOIN catalogs c
  ON p.catalog_id = c.id
ORDER BY name;
SELECT * FROM prod_name;

/* Задание 3
 * (по желанию) Пусть имеется таблица с календарным полем created_at. 
 * В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04',
 *  '2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август,
 *  выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.*/

USE sample;

DROP TABLE IF EXISTS posts;
CREATE TABLE IF NOT EXISTS posts (
 id SERIAL PRIMARY KEY,
 name VARCHAR(255),
 created_at DATE NOT NULL
);

INSERT INTO posts VALUES
(NULL, 'one', '2018-08-01'),
(NULL, 'two', '2018-08-04'),
(NULL, 'three', '2018-08-16'),
(NULL, 'four', '2018-08-17');


CREATE TEMPORARY TABLE last_days (
day INT
);

INSERT INTO last_days VALUES
(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10),
(11), (12), (13), (14), (15), (16), (17), (18), (19), (20),
(21), (22), (23), (24), (25), (26), (27), (28), (29), (30);

-- результат через временную таблицу
SELECT
 DATE(DATE('2018-08-31') - INTERVAL l.day DAY) AS day,
 NOT ISNULL(p.name) AS order_exist
FROM
 last_days AS l
LEFT JOIN
 posts AS p
ON
 DATE(DATE('2018-08-31') - INTERVAL l.day DAY) = p.created_at
ORDER BY
 day;


-- результат через рекрсивное выражение
SELECT s.check_date, NOT ISNULL(p.name) order_exist FROM (
WITH RECURSIVE sequence AS (
 SELECT 0 AS level
 UNION ALL
 SELECT level + 1 AS value FROM sequence WHERE sequence.level < 30
)
SELECT DATE(DATE('2018-08-31') - INTERVAL s.level DAY) AS check_date
FROM `sequence` s
) s
LEFT JOIN posts p ON p.created_at = s.check_date
ORDER BY 1;


 
/* Задание 4
 * (по желанию) Пусть имеется любая таблица с календарным полем created_at. 
 * Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.*/

USE shop;

-- создаем копию таблицы orders
DROP TABLE IF EXISTS orders_1;
CREATE TABLE orders_1 (
  id SERIAL PRIMARY KEY,
  user_id INT UNSIGNED,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY index_of_user_id(user_id)
) COMMENT = 'Заказы_копия';

-- заполняем таблицу orders_1 данными
INSERT INTO orders_1 (id, user_id, created_at, updated_at) SELECT * FROM orders;

-- результат
START TRANSACTION;
CREATE VIEW last_5_dates AS SELECT * FROM orders_1 ORDER BY updated_at DESC LIMIT 5;
DELETE FROM orders_1 WHERE id NOT IN (SELECT id FROM last_5_dates);
DROP VIEW last_5_dates;
COMMIT;


/* Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию) */

/* Задание 1
 * Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read
 *  должны быть доступны только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.*/

DROP USER IF EXISTS 'shop_read'@'localhost';
CREATE USER IF NOT EXISTS 'shop_read'@'localhost' identified BY 'password';
GRANT SELECT, SHOW VIEW ON shop.* TO 'shop_read'@'localhost';

DROP USER IF EXISTS 'shop'@'localhost';
CREATE USER IF NOT EXISTS 'shop'@'localhost' identified BY 'password';
GRANT ALL ON shop.* TO 'shop'@'localhost';

SHOW grants FOR 'shop_read'@'localhost';
SHOW grants FOR 'shop'@'localhost';

/* Задание 2
 * (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ,
 *  имя пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name.
 *  Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.*/

USE shop;

DROP TABLE IF EXISTS accounts;
CREATE TABLE IF NOT EXISTS accounts (
 id SERIAL PRIMARY KEY,
 name VARCHAR(255),
 password VARCHAR(255)
 );

INSERT INTO `accounts` VALUES 
(1,'Moriah','b597e4007d365f32cc25d1ba6d50a93a374fe5a8'),
(2,'Beau','6bc537e7743977f18eb48ee0f59c241dbccc6151'),
(3,'Joe','4e52e159b9210d7adb0c3ee45ce973a4a9ed356c'),
(4,'Laurel','50927a399322f99681ed8c575e634306cdd0aa83'),
(5,'Jamel','3582d38a26edd2bb4f2f8c1ec67661aaa29e973f'),
(6,'Khalid','762930fbe70c0fd48c1619e38013c018bd8afa55'),
(7,'Braulio','a749a2b2d85674ddc3aa87a0fc128f0461863944'),
(8,'Kelton','ea1b2d1ea8a948322f5b5896e896ff8d934b2781'),
(9,'Garth','d7aa57dbe15eda480bcf3c073b9efb333172a2fa'),
(10,'Crawford','f61e62bd72563fc659a20f587d238f1d24bcee4d');


CREATE OR REPLACE VIEW username AS SELECT id, name FROM accounts;

SELECT * FROM username;

DROP USER IF EXISTS 'user_read'@'localhost';
CREATE USER IF NOT EXISTS 'user_read'@'localhost' identified BY 'password';
GRANT SELECT (id, name) ON shop.username TO 'user_read'@'localhost';

SHOW grants FOR 'user_read'@'localhost';

/* Практическое задание по теме “Хранимые процедуры и функции, триггеры" */

/* Задание 1
 * Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 *  С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу
 *  "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".*/

-- функция
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello (hh INT)
RETURNS TEXT DETERMINISTIC
BEGIN
  IF (hh > 6 AND hh <= 12) THEN
      RETURN  "Доброе утро";
  END IF;
  IF (hh > 12 AND hh <= 18) THEN
      RETURN "Добрый день";
  END IF;
  IF (hh > 18 AND hh <= 24) THEN
      RETURN "Добрый вечер";
  END IF;
  IF (hh > 0 AND hh <= 6) THEN
      RETURN "Доброй ночи";
  END IF;
END//
SET @t = DATE_FORMAT(CURRENT_TIMESTAMP, '%H')//
SELECT hello(@t)//

-- процедура
DROP PROCEDURE IF EXISTS hello//
CREATE PROCEDURE hello ()
BEGIN
 SET @t = DATE_FORMAT(CURRENT_TIMESTAMP, '%H');
  IF (@t > 6 AND @t <= 12) THEN
      SELECT "Доброе утро" AS 'greetings';
  END IF;
  IF (@t > 12 AND @t <= 18) THEN
      SELECT "Добрый день" AS 'greetings';
  END IF;
  IF (@t > 18 AND @t <= 24) THEN
      SELECT "Добрый вечер" AS 'greetings';
  END IF;
  IF (@t > 0 AND @t <= 6) THEN
      SELECT "Доброй ночи" AS 'greetings';
  END IF;
END//
CALL hello()//


/* Задание 2
 * В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 *  Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное
 *  значение NULL неприемлема. Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля
 *  были заполнены. При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

USE shop;

-- результат
DROP TRIGGER IF EXISTS check_prod_info_insert//
CREATE TRIGGER check_prod_info_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF (NEW.name IS NULL) AND (NEW.description IS NULL) THEN
    	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Оба поля name и description не могут быть пустыми"; 
  	END IF;
END//

/* Задание 3
 * (по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
 *  Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
 *  Вызов функции FIBONACCI(10) должен возвращать число 55.*/

USE shop;


-- результат
DROP FUNCTION IF EXISTS fibonacci//
CREATE FUNCTION fibonacci (num INT)
RETURNS INT DETERMINISTIC
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE num2 INT DEFAULT 0;
	WHILE i <= num DO
	  SET num2 = num2 + i;
  	  SET i = i + 1;
	END WHILE;
	
	RETURN num2;
END//

SET @num = 10//
SELECT fibonacci(@num)//
