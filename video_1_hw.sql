CREATE DATABASE IF NOT EXISTS example;
USE example;
drop table if exists users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT 'ФИО пользователя'
);

INSERT INTO users VALUES
(NULL, 'Иванов Иван Иванович'),
(NULL, 'Петров Пертр Петрович'),
(NULL, 'Сидоров Сидор Сидорович');

-- mysqldump example > example_dump.sql # команда в консоли

-- CREATE DATABASE IF NOT EXISTS sample;

-- mysql sample < example_dump.sql # команда в консоли

USE sample;
SELECT * FROM users;

-- Задание 4
-- mysqldump mysql help_keyword --where="true limit 100" > mysql_dump.sql;
