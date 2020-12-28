USE shop;

/* Практическое задание по теме «Операторы, фильтрация, сортировка и ограничение» */

/* Задание 1
 * Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */

TRUNCATE TABLE users; 
INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
   ('admin', '2001-11-03', NOW(), NOW()),
   ('sem', '1985-08-12', NOW(), NOW()),
   ('manager', '1973-01-15', NOW(), NOW());

SELECT * FROM users;

/* Задание 2
 * Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
 *  и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME,
 *  сохранив введённые ранее значения. */


DROP TABLE IF EXISTS users;
CREATE TABLE users (
id SERIAL PRIMARY KEY COMMENT 'ID пользователя',
name VARCHAR(255) COMMENT 'ФИО пользователя',
birthday_at DATE COMMENT 'Дата рождения',
created_at VARCHAR(20) COMMENT 'Время создания строки',  
updated_at VARCHAR(20) COMMENT 'Время обновления строки'
) COMMENT 'Таблица пользователей';

TRUNCATE TABLE users;
INSERT INTO users (name, birthday_at, created_at, updated_at) VALUES
   ('admin', '2001-11-03', '15.09.2008 9:10', '12.11.2018 12:43'),
   ('sem', '1985-08-12', '02.03.2014 11:18', '23.11.2019 14:38'),
   ('manager', '1973-01-15', '01.03.2016 10:12', '16.02.2020 17:01');
  

 UPDATE users SET 
   created_at = STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'),
   updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
  
ALTER TABLE users MODIFY COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки';
ALTER TABLE users MODIFY COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки';

SELECT * FROM users;

/* Задание 3
 * В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 *  0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи
 *  таким образом, чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны
 *  выводиться в конце, после всех  */

TRUNCATE TABLE storehouses;
INSERT INTO storehouses (name) VALUES
   ('main'),
   ('opt');
  
TRUNCATE TABLE products;
INSERT INTO products (name, description, price, catalog_id) VALUES
   ('Процессор 1', 'Процессор 1', 12467, 1),
   ('Процессор 2', 'Процессор 2', 7452, 1),
   ('Мат. плата 1', 'Мат. плата 1', 4367, 2),
   ('Мат. плата 2', 'Мат. плата 2', 11243, 2),
   ('Видеокарта 1', 'Видеокарта 1', 36457, 3),
   ('Видеокарта 2', 'Видеокарта 2', 74611, 3);

  
TRUNCATE TABLE storehouses_products;
INSERT INTO storehouses_products (storehouse_id, product_id, volume) VALUES
   (1, (SELECT id FROM products ORDER BY rand() LIMIT 1), 12),
   (1, (SELECT id FROM products ORDER BY rand() LIMIT 1), 7),
   (1, (SELECT id FROM products ORDER BY rand() LIMIT 1), 0),
   (2, (SELECT id FROM products ORDER BY rand() LIMIT 1), 24),
   (2, (SELECT id FROM products ORDER BY rand() LIMIT 1), 0),
   (2, (SELECT id FROM products ORDER BY rand() LIMIT 1), 15);
  
-- вывод значений
SELECT volume FROM storehouses_products ORDER BY IF(volume > 0, 0, 1), volume;

/*  Задание 4
 * (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
 *  Месяцы заданы в виде списка английских названий (may, august) */

SELECT name, date_format(birthday_at, '%M') AS month FROM users HAVING month IN ('may', 'august');

/* Задание 5
 * (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
 *  SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN. */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY id=5 DESC, id=1 DESC, id=2 DESC;



/* Практическое задание теме «Агрегация данных» */

/*  Задание 1
 * Подсчитайте средний возраст пользователей в таблице users. */

SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS avg_age FROM users;

/*  Задание 2
 * Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
 *  Следует учесть, что необходимы дни недели текущего года, а не года рождения. */

-- SELECT birthday_at FROM users;
-- SELECT DAYNAME(birthday_at) AS day FROM users;
SELECT DAYNAME(CONCAT(SUBSTRING(NOW(), 1, 4), '-', SUBSTRING(birthday_at, 6, 5))) AS day FROM users;

/*  Задание 3
 * (по желанию) Подсчитайте произведение чисел в столбце таблицы. */


DROP TABLE IF EXISTS case3;
CREATE TABLE case3 (
id SERIAL PRIMARY KEY COMMENT 'ID записи',
value int(10) unsigned NOT NULL COMMENT 'Значение'
);

TRUNCATE TABLE case3;
INSERT INTO case3 (value) VALUES
   (1),
   (2),
   (3),
   (4),
   (5);

-- логарифм произведения равен сумме логарифмов
SELECT EXP(SUM(LOG(value))) AS div_val FROM case3;
