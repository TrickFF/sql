/* Практическое задание по теме “Оптимизация запросов” */

/*Задание 1
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users,
 *  catalogs и products в таблицу logs помещается время и дата создания записи,
 *  название таблицы, идентификатор первичного ключа и содержимое поля name.*/

USE shop;

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор сроки',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `table_name` VARCHAR(255) NOT NULL COMMENT 'Название таблицы',
  `name` VARCHAR(255) COMMENT 'Название товара',
  PRIMARY KEY (`id`)
)  COMMENT 'Архив' ENGINE = Archive;


DELIMITER //

DROP TRIGGER IF EXISTS trg_users_logs//
CREATE TRIGGER trg_users_logs AFTER INSERT ON users
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET 
   	   table_name = 'users',
   	   name = NEW.name;
END//


DELIMITER //

DROP TRIGGER IF EXISTS trg_catalogs_logs//
CREATE TRIGGER trg_catalogs_logs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET 
   	   table_name = 'catalogs',
   	   name = NEW.name;
END//


DELIMITER //

DROP TRIGGER IF EXISTS trg_products_logs//
CREATE TRIGGER trg_products_logs AFTER INSERT ON products
FOR EACH ROW 
BEGIN
	INSERT INTO logs SET 
   	   table_name = 'products',
   	   name = NEW.name;   					
END//

show triggers;

DELIMITER ;

-- тестовые данные
INSERT INTO users (name, birthday_at) VALUES
  ('user1', '1976-12-10'),
  ('user2', '1993-06-08');
 
INSERT INTO catalogs (name) VALUES
  ('Жесткие диски'),
  ('Корпуса');
 
INSERT INTO products
  (name, description, price, catalog_id)
VALUES
  ('Seagate', 'HDD 15000 об/сек', 3547, 4),
  ('Thermaltake 700W', 'С блоком питания', 6590, 5);
 
SELECT * FROM logs; 
 
/*Задание 2
 * (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.*/

-- результат
/* Запрос получается слишком громоздкий,
 * реализовал в виде процедуры */

DELIMITER //

DROP PROCEDURE IF EXISTS usr_add//
CREATE PROCEDURE usr_add ()
BEGIN
set @i=1;
  WHILE @i<=1000000 DO
    set @n=CONCAT('user', @i);	
    set @p='1954-01-01' + INTERVAL RAND()*365*25 DAY;
    insert into users (name, birthday_at) values (@n,@p);
    set @i=@i+1;
  END WHILE;
END//

CALL usr_add()//

SELECT * FROM users;

/* Практическое задание по теме “NoSQL” */

/* Задание 1
В базе данных Redis подберите коллекцию для подсчета посещений с определенных IP-адресов. */

-- решение
/* Учитывая, что в задании указано подобрать именно коллекцию, то заносим в хэш дату/время входа для 
каждого IP адреса */

HSET 192.168.10.15 1 "2017-11-08" 2 "2018-06-05" 3 "2019-02-02"
HVALS 192.168.10.15


/* Задание 2
При помощи базы данных Redis решите задачу поиска имени пользователя по электронному адресу и наоборот, 
поиск электронного адреса пользователя по его имени. */

-- решение по поиску email по имени пользователя

HSET Olga email "olga@mail.ru" phone "+7(812)987-65-43" skype "olga123"
HGET Olga email


-- решение по поиску имени пользователя по email
/* Смысл решения в том, что email пользователя, которого мы ищем добавляется в новую коллекцию, затем 
методом сравнения ищется коллекция в которой будет общее поле. */

SADD Olga "phone:+7812-987-65-34" "email:olga@mail.ru" "skype:olga123"
SADD newuser "email:olga@mail.ru"
SINTER Olga newuser


/* Задание 3
Организуйте хранение категорий и товарных позиций учебной базы данных shop в СУБД MongoDB. */

-- В отдельном файле shop.json (структура создана в robomongo)

