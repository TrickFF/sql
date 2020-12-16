USE shop;
drop table if exists catalogs;
CREATE TABLE catalogs (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '�������� �������',
UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO catalogs VALUES
(NULL, '����������'),
(NULL, '���.�����'),
(NULL, '����������');

drop table if exists cat;
CREATE TABLE cat (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '�������� �������',
UNIQUE unique_name(name(10))
) COMMENT = '������� ��������-��������';

INSERT INTO
 cat
SELECT
 *
FROM
 catalogs;

SELECT * FROM cat;

drop table if exists users;
CREATE TABLE users (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '��� ����������',
birthday_at DATE COMMENT '���� �������� ����������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '����������';

drop table if exists products;
CREATE TABLE products (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '��������',
description TEXT COMMENT '��������',
price DECIMAL (11,2) COMMENT '����',
catalog_id INT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_catalog_id(catalog_id)
) COMMENT = '�������� �������';

drop table if exists orders;
CREATE TABLE orders (
id SERIAL PRIMARY KEY,
user_id INT UNSIGNED,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_user_id(user_id)
) COMMENT = '������';

drop table if exists orders_products;
CREATE TABLE orders_products (
id SERIAL PRIMARY KEY,
order_id INT UNSIGNED,
product_id INT UNSIGNED,
total INT UNSIGNED DEFAULT 1 COMMENT '���-�� ���������� �������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
-- KEY index_of_order_id(order_id, product_id),
-- KEY index_of_product_id(product_id, order_id)
) COMMENT = '������ ������';

drop table if exists discounts;
CREATE TABLE discounts (
id SERIAL PRIMARY KEY,
user_id INT UNSIGNED,
product_id INT UNSIGNED,
discount FLOAT UNSIGNED COMMENT '�������� ������ �� 0.0 �� 1.0',
started_at DATETIME,
finished_at DATETIME,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
KEY index_of_user_id(user_id),
KEY index_of_product_id(product_id)
) COMMENT = '������';

drop table if exists storehouses;
CREATE TABLE storehouses (
id SERIAL PRIMARY KEY,
name VARCHAR(255) COMMENT '��������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������';

drop table if exists storehouses_pruducts;
CREATE TABLE storehouses_pruducts (
id SERIAL PRIMARY KEY,
storehouse_id INT UNSIGNED,
product_id INT UNSIGNED,
volume INT UNSIGNED COMMENT '����� ������ �� ������',
created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = '������ �� ������';


