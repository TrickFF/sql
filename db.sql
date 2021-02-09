/* Курсовой проект по предмету "Основы реляционных баз данных. MySQL"
 * В рамках проекта реализована предполагаемая БД сервиса по доставке продуктов из сетевых магазинов igoods */

/* Проядок действий для проверки:
 * 1. Создать базу
 * 2. Создать таблицы, триггеры, индексы
 * 3. Создать триггеры
 * 4. Внести тестовые данные
 * 5. Использовать запросы/представления/тестировать триггеры*/

DROP DATABASE IF EXISTS igoods;
CREATE DATABASE IF NOT EXISTS igoods;

USE igoods;


-- Таблица фото пользователей/сотрудников и товаров
DROP TABLE IF EXISTS `images`;
CREATE TABLE `images` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `filename` varchar(255) NOT NULL COMMENT 'Путь к файлу',
  `size` int NOT NULL COMMENT 'Размер файла',
  `metadata` longtext COMMENT 'Метаданные файла',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT='Таблица ссылок на фото и их описания';


-- Таблица пользователей системы
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` VARCHAR(255) COMMENT 'ФИО пользователя',
  `photo_id` int unsigned DEFAULT NULL COMMENT 'Ссылка на основную фотографию пользователя',
  `email` varchar(100) NOT NULL COMMENT 'Почта',
  `phone` varchar(100) NOT NULL COMMENT 'Телефон',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Пользователи';


-- внешний ключ для таблицы пользователй
ALTER TABLE users DROP CONSTRAINT users_photo_id_fk;
ALTER TABLE users
  ADD CONSTRAINT users_photo_id_fk FOREIGN KEY (photo_id) REFERENCES images(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

-- индекс для ускорения поиска пользователей по имени
CREATE INDEX users_name_idx ON users(name);



/* В идеале в целях сокращения размера баз и времени обработки данных следует вынести города и адреса в отдельные таблицы,
 * но время на реализацию проекта ограничено и эти данные заносятся в прямом виде*/
  
-- Таблица адресов пользователей
DROP TABLE IF EXISTS `users_addresses`;
CREATE TABLE IF NOT EXISTS `users_addresses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `city` varchar(100) NOT NULL COMMENT 'Город пользователя',
  `street` varchar(100) NOT NULL COMMENT 'Улица',
  `building` varchar(20) NOT NULL COMMENT 'Дом, корпус',
  `room` varchar(20) NOT NULL COMMENT 'Квартира/офис',
  `floor` varchar(20) NOT NULL COMMENT 'Этаж',
  `door` varchar(20) NOT NULL COMMENT 'Подъезд',
  `entrance` tinyint(1) DEFAULT 0 COMMENT 'Вход',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Адреса пользователей';

-- внешний ключ для таблицы адресаов пользователей
ALTER TABLE users_addresses DROP CONSTRAINT users_addresses_user_id_fk;
ALTER TABLE users_addresses 
  ADD CONSTRAINT users_addresses_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- индекс для ускорения логистических процессов
CREATE INDEX users_addresses_city_street_idx ON users_addresses(city, street);

 
-- Таблица платежных систем
DROP TABLE IF EXISTS `payment_types`;
CREATE TABLE IF NOT EXISTS `payment_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` VARCHAR(20) COMMENT 'Тип платежной системы',
  `info` VARCHAR(255) COMMENT 'Описание типа карты',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Справочник платежных систем'; 
  
  
-- Таблица видов платежей пользователей
DROP TABLE IF EXISTS `users_payments`;
CREATE TABLE IF NOT EXISTS `users_payments` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на пользователя',
  `payment_type_id` int unsigned NOT NULL COMMENT 'Ссылка на платежную систему',
  `number` VARCHAR(30) COMMENT 'Номер карты/кошелька',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Виды платежей пользователей'; 

-- внешний ключ для таблицы видов платежей пользователей
ALTER TABLE users_payments DROP CONSTRAINT users_payments_user_id_fk,
  DROP CONSTRAINT users_payments_payment_type_id_fk;
ALTER TABLE users_payments 
  ADD CONSTRAINT users_payments_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT users_payments_payment_type_id_fk FOREIGN KEY (payment_type_id) REFERENCES payment_types(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

  
-- Таблица брэндов сетей
DROP TABLE IF EXISTS `brands`;
CREATE TABLE IF NOT EXISTS `brands` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` VARCHAR(20) COMMENT 'Брэнд сети магазинов',
  `info` VARCHAR(255) COMMENT 'Описание брэнда сети магазинов',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Справочник брэндов сетей';  
  

-- Таблица магазинов
DROP TABLE IF EXISTS `shops`;
CREATE TABLE IF NOT EXISTS `shops` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `brand_id` int unsigned NOT NULL COMMENT 'Ссылка на брэнд сети магазинов',
  `city` varchar(100) NOT NULL COMMENT 'Город расположения',
  `street` varchar(100) NOT NULL COMMENT 'Улица',
  `building` varchar(20) NOT NULL COMMENT 'Дом, корпус',
  `note` varchar(255) COMMENT 'Примечание',
  `actual` tinyint(1) DEFAULT 0 COMMENT 'Доступность для выбора. По умолчанию новый магазин недоступен',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Справочник магазинов';

-- внешний ключ для таблицы адресаов пользователей
ALTER TABLE shops DROP CONSTRAINT shops_brand_id_fk;
ALTER TABLE shops 
  ADD CONSTRAINT shops_brand_id_fk FOREIGN KEY (brand_id) REFERENCES brands(id)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- индекс для ускорения логистических процессов
CREATE INDEX shops_city_street_idx ON shops(city, street); 
  
  
/* Учитывая, что для категоризации товаров используется только одна вложенность подкатегорий, то реализуем это через 2 таблицы:
 *  категории и подкатегории. В иных случаях для простоты масштабирования вложенности было бы удобней использовать 1 таблицу
 *  с доп. полем. с ID родительских категори (0 - для категорий верхнего уровня)*/  
  
-- Таблица категорий товаров
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) NOT NULL COMMENT 'Название категории',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Категории товаров';


-- Таблица подкатегорий товаров
DROP TABLE IF EXISTS `subcategories`;
CREATE TABLE IF NOT EXISTS `subcategories` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `cat_id` int unsigned NOT NULL COMMENT 'Ссылка на категорию',
  `name` varchar(100) NOT NULL COMMENT 'Название подкатегории',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Подкатегории товаров';

  
-- внешний ключ для таблицы подкатегорий товаров
ALTER TABLE subcategories DROP CONSTRAINT subcategories_cat_id_fk;
ALTER TABLE subcategories 
  ADD CONSTRAINT subcategories_cat_id_fk FOREIGN KEY (cat_id) REFERENCES categories(id)
    ON DELETE CASCADE ON UPDATE CASCADE;
   
   
-- Таблица производителей товаров
DROP TABLE IF EXISTS `manufacturers`;
CREATE TABLE IF NOT EXISTS `manufacturers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) NOT NULL COMMENT 'Название производителя',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Таблица производителей товаров';

-- индекс таблицы производителей по названию производителя для сокращения времени поиска и возможности создания поля со списком
CREATE INDEX manufacturers_name_idx ON manufacturers(name);


-- Таблица единиц измерения
DROP TABLE IF EXISTS `units`;
CREATE TABLE IF NOT EXISTS `units` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(10) COMMENT 'Название единицы измерения',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Таблица единиц измерения';
   
  
-- Таблица товаров
DROP TABLE IF EXISTS `goods`;
CREATE TABLE IF NOT EXISTS `goods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `photo_id` int unsigned DEFAULT NULL COMMENT 'Ссылка на фотографию товара',
  `subcat_id` int unsigned NOT NULL COMMENT 'Ссылка на подкатегорию',
  `man_id` int unsigned NOT NULL COMMENT 'Ссылка на производителя',
  `name` varchar(100) NOT NULL COMMENT 'Название товара',
  `weight` float(24) COMMENT 'Вес товара',
  `unit_id` int unsigned NOT NULL COMMENT 'Ссылка на единицы измерения',
  `note` varchar(255) COMMENT 'Примечание',
  `metadata` JSON COMMENT 'Метаданные товара',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Таблица товаров';

-- внешний ключ для таблицы товаров
ALTER TABLE goods DROP CONSTRAINT goods_subcat_id_fk,
  DROP CONSTRAINT goods_man_id_fk,
  DROP CONSTRAINT goods_unit_id_fk,
  DROP CONSTRAINT goods_photo_id_fk;
ALTER TABLE goods 
  ADD CONSTRAINT goods_subcat_id_fk FOREIGN KEY (subcat_id) REFERENCES subcategories(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT goods_man_id_fk FOREIGN KEY (man_id) REFERENCES manufacturers(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT goods_unit_id_fk FOREIGN KEY (unit_id) REFERENCES units(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT goods_photo_id_fk FOREIGN KEY (photo_id) REFERENCES images(id)
    ON DELETE CASCADE ON UPDATE CASCADE;
   
-- индекс таблицы товаров по названию товара для сокращения времени поиска
CREATE INDEX goods_name_idx ON goods(name);
   


  -- Таблица выполняемых работ при обработке заказа
DROP TABLE IF EXISTS `work_type`;
CREATE TABLE IF NOT EXISTS `work_type` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(100) NOT NULL COMMENT 'Наименование работ',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Таблица работ при обработке заказа'; 
 
  
  
-- Таблица сотрудников по обработке заказов
DROP TABLE IF EXISTS `workers`;
CREATE TABLE IF NOT EXISTS `workers` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `work_type_id` int unsigned COMMENT 'Ссылка на должность сотрудника',
  `shop_id` int unsigned COMMENT 'Ссылка на закрепленный за сотрудником магазин',
  `name` VARCHAR(255) COMMENT 'ФИО сотрудника',
  `photo_id` int unsigned DEFAULT NULL COMMENT 'Ссылка на фотографию сотрудника',
  `email` varchar(100) NOT NULL COMMENT 'Почта',
  `phone` varchar(100) NOT NULL COMMENT 'Телефон',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Сотрудники';

-- внешний ключ для таблицы товаров
ALTER TABLE workers DROP CONSTRAINT workers_work_type_id_fk,
   DROP CONSTRAINT workers_shop_id_fk,
   DROP CONSTRAINT workers_photo_id_fk;
ALTER TABLE workers 
  ADD CONSTRAINT workers_work_type_id_fk FOREIGN KEY (work_type_id) REFERENCES work_type(id)
    ON DELETE set null ON UPDATE set null,
  ADD CONSTRAINT workers_shop_id_fk FOREIGN KEY (shop_id) REFERENCES shops(id)
    ON DELETE set null ON UPDATE set null,
  ADD CONSTRAINT workers_photo_id_fk FOREIGN KEY (photo_id) REFERENCES images(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION;  

  
 -- Таблица каталога товаров. Создается в памяти дял ускорения загрузки данных для пользователей
DROP TABLE IF EXISTS `catalog`;
CREATE TABLE `catalog` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `shop_id` int unsigned COMMENT 'Ссылка на магазин',
  `goods_id` int unsigned COMMENT 'Ссылка на товар',
  `price` FLOAT(15) unsigned COMMENT 'Цена товара',
  `quantity` FLOAT(10) unsigned DEFAULT 0 COMMENT 'Количество товара в запасах',
  `in_orders` FLOAT(10) unsigned DEFAULT 0 COMMENT 'Количество товара, зарезервированного в заказах',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Каталог товаров';
  
  
-- внешний ключ для таблицы товаров
ALTER TABLE `catalog` DROP CONSTRAINT catalog_shop_id_fk,
   DROP CONSTRAINT catalog_goods_id_fk;
ALTER TABLE `catalog` 
  ADD CONSTRAINT catalog_shop_id_fk FOREIGN KEY (shop_id) REFERENCES shops(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT catalog_goods_id_fk FOREIGN KEY (goods_id) REFERENCES goods(id)
    ON DELETE CASCADE ON UPDATE CASCADE;
   
-- индекс каталога проукции для удобства сортировки продукции по магазинам и невозможности вставки дубликата в одном и том же магазине
CREATE UNIQUE INDEX catalog_shop_goods_idx ON catalog(shop_id, goods_id);
  
  
   -- Таблица заказов
DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `shop_id` int unsigned COMMENT 'Ссылка на магазин',
  `user_id` int unsigned COMMENT 'Ссылка на пользователя',
  `users_addresses_id` int unsigned COMMENT 'Ссылка на адрес доставки',
  `user_payment_id` int unsigned COMMENT 'Ссылка на способ оплаты',
  `order_status` ENUM('Создан', 'Собирается', 'Собран', 'Доставляется', 'Доставлен', 'Закрыт', 'Отменен') DEFAULT 'Создан' COMMENT 'Статус заказа',
  `collector_id` int unsigned COMMENT 'Ссылка сборщика заказа',
  `curier_id` int unsigned COMMENT 'Ссылка на курьера',
  `price` FLOAT(15) unsigned COMMENT 'Предварительная цена заказа',
  `price_fact` FLOAT(15) unsigned COMMENT 'Фактическая цена заказа',
  `payment_status` ENUM('Ожидается оплата', 'Подтверждение оплаты', 'Заказ оплачен') DEFAULT 'Ожидается оплата' COMMENT 'Статус оплаты заказа', 
  `note` varchar(255) COMMENT 'Примечание',
  `deliver_on` datetime NOT NULL COMMENT 'Время к которому нужно доставить',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Заказы';

-- внешний ключ для таблицы заказов
ALTER TABLE `orders` DROP CONSTRAINT orders_shop_id_fk,
  DROP CONSTRAINT orders_user_id_fk,
  DROP CONSTRAINT orders_users_addresses_id_fk,
  DROP CONSTRAINT orders_user_payment_id_fk,
  DROP CONSTRAINT orders_collector_id_fk,
  DROP CONSTRAINT orders_curier_id_fk;
ALTER TABLE `orders` 
  ADD CONSTRAINT orders_shop_id_fk FOREIGN KEY (shop_id) REFERENCES shops(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_user_id_fk FOREIGN KEY (user_id) REFERENCES users(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_users_addresses_id_fk FOREIGN KEY (users_addresses_id) REFERENCES users_addresses(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_user_payment_id_fk FOREIGN KEY (user_payment_id) REFERENCES users_payments(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_collector_id_fk FOREIGN KEY (collector_id) REFERENCES workers(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_curier_id_fk FOREIGN KEY (curier_id) REFERENCES workers(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION;
  
 -- индекс таблицы заказов по времени доставки для возможности оперативно расставлять приоритеты
CREATE INDEX orders_deliver_on_idx ON orders(deliver_on);

   
   -- Таблица товаров в заказах
DROP TABLE IF EXISTS `orders_goods`;
CREATE TABLE `orders_goods` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `order_id` int unsigned COMMENT 'Ссылка на заказ',
  `catalog_id` int unsigned COMMENT 'Ссылка на товар в каталоге',
  `quantity_in_order` FLOAT(10) unsigned DEFAULT 0 COMMENT 'Количество товара в заказе',
  `quantity_collected` FLOAT(10) unsigned DEFAULT 0 COMMENT 'Количество товара в заказе',
  `changed_catalog_id` int unsigned DEFAULT NULL COMMENT 'Ссылка на товар в случае замены',
  `position_staus` tinyint(1) DEFAULT 0 COMMENT 'Статус товара в заказе. 0 - комплектация, 1 - собран',
  `note` varchar(255) COMMENT 'Примечание',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
) COMMENT 'Товары в заказах';  
  
-- внешний ключ для товаров в заказах
ALTER TABLE `orders_goods` DROP CONSTRAINT orders_goods_order_id_fk,
  DROP CONSTRAINT orders_goods_catalog_id_fk,
  DROP CONSTRAINT orders_goods_changed_catalog_id_fk;
ALTER TABLE `orders_goods` 
  ADD CONSTRAINT orders_goods_order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_goods_catalog_id_fk FOREIGN KEY (catalog_id) REFERENCES catalog(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT orders_goods_changed_catalog_id_fk FOREIGN KEY (changed_catalog_id) REFERENCES catalog(id)
    ON DELETE NO ACTION ON UPDATE NO ACTION;

 /* индекс таблицы товаров в заказах для ускорения формирования комплектовочных листов и поиска товаров в заказах 
  * а также для невозможности повторного выбора одного и того же товара в заказе*/
 CREATE UNIQUE INDEX orders_goods_order_id_catalog_id_idx ON orders_goods(order_id, catalog_id);
 -- DROP INDEX orders_goods_order_id_catalog_id_idx ON orders_goods;



-- Не успел продумать и создать таблицы скидок и расчет стоимости товаров с их учетм
