CREATE DATABASE IF NOT EXISTS example;
USE example;
drop table if exists users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '��� ������������'
);

INSERT INTO users VALUES
(NULL, '������ ���� ��������'),
(NULL, '������ ����� ��������'),
(NULL, '������� ����� ���������');

-- mysqldump example > example_dump.sql # ������� � �������

-- CREATE DATABASE IF NOT EXISTS sample;

-- mysql sample < example_dump.sql # ������� � �������

USE sample;
SELECT * FROM users;

-- ������� 4
-- mysqldump mysql help_keyword --where="true limit 100" > mysql_dump.sql;
