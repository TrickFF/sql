-- Триггер обновления планируемой стоимости заказа при изменении количества какой-либо позиции
-- На обновление
DROP TRIGGER IF EXISTS order_price_update;

DELIMITER //

CREATE TRIGGER order_price_update
    AFTER UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
	IF NEW.quantity_in_order <> OLD.quantity_in_order THEN
      SET @id = NEW.order_id;
      UPDATE orders SET price = (SELECT SUM(c.price * og.quantity_in_order) FROM orders_goods og JOIN catalog c ON c.id = og.catalog_id WHERE og.order_id = @id) WHERE id = @id;
    END IF;
END//

-- Тест
UPDATE orders_goods SET quantity_in_order = 6 WHERE id = 1; 
SELECT * FROM orders;
SELECT * FROM orders_goods;

-- На вставку
DROP TRIGGER IF EXISTS order_price_insert;

DELIMITER //

CREATE TRIGGER order_price_insert
    AFTER INSERT
    ON orders_goods FOR EACH ROW
BEGIN
    SET @id = NEW.order_id;
    UPDATE orders SET price = (SELECT SUM(c.price * og.quantity_in_order) FROM orders_goods og JOIN catalog c ON c.id = og.catalog_id WHERE og.order_id = @id) WHERE id = @id;
END//

-- Тест
START TRANSACTION;
SELECT * FROM orders;
SELECT * FROM orders_goods;
INSERT INTO orders_goods (order_id, catalog_id, quantity_in_order, quantity_collected, note) VALUES
   (1, 4, 6, 7, 'Товар id4 в заказе 1 TEST');
ROLLBACK;
COMMIT; 


-- Триггер обновления фактической стоимости заказа при изменении количества собранного товара
DROP TRIGGER IF EXISTS order_price_fact_update;

DELIMITER //

CREATE TRIGGER order_price_fact_update
    AFTER UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
	IF NEW.quantity_collected <> OLD.quantity_collected THEN
      SET @id = NEW.order_id;
      UPDATE orders SET price_fact = (SELECT SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
        then price * quantity_collected
        else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
        FROM orders_goods WHERE id = og.id)) AS fact_order_price 
     FROM orders_goods og
     JOIN catalog c ON c.id = catalog_id
     WHERE order_id = @id) WHERE id = @id;
   END IF;
END//

-- Тест
SELECT * FROM orders;
SELECT * FROM orders_goods;
UPDATE orders_goods SET quantity_collected = 5 WHERE id = 1;

-- Триггер на вставку фактически собранной продукции можно не делать, т.к. вставка записи будет выполнена до начала сборки продукции



-- Триггер на проверку невозможности выбора одного и тогже сотрудника в качестве сборщика и курьера одновременно
-- При вставке новой строки
DROP TRIGGER IF EXISTS orders_collector_and_curier_insert;

DELIMITER //

CREATE TRIGGER orders_collector_and_curier_insert BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	IF NEW.collector_id = NEW.curier_id THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose same person to collect and deliver the order!'; 
  	END IF;
END//

-- Тест
INSERT INTO orders (shop_id, user_id, users_addresses_id, user_payment_id, collector_id, curier_id, deliver_on) VALUES
   (1, 1, 2, 1, 1, 1, CURRENT_TIMESTAMP + INTERVAL 3 HOUR);

-- При обновлении строки
DROP TRIGGER IF EXISTS orders_collector_and_curier_update;

DELIMITER //

CREATE TRIGGER orders_collector_and_curier_update BEFORE UPDATE ON orders
FOR EACH ROW
BEGIN
	IF NEW.collector_id = OLD.curier_id THEN
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'You cant choose same person to collect and deliver the order!';
    END IF;
    IF NEW.curier_id = OLD.collector_id THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose same person to collect and deliver the order!';
  	END IF;
END//

-- Тест
UPDATE orders SET collector_id = 2 WHERE id = 3;
UPDATE orders SET curier_id = 1 WHERE id = 3;



-- Триггер на проверку невозможности выбора сборщика заказа в качестве курьера и наоборот
DROP TRIGGER IF EXISTS orders_collector_curier_insert;

DELIMITER //

CREATE TRIGGER orders_collector_curier_insert BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
	IF NEW.collector_id >= 0 AND (SELECT w.work_type_id FROM workers w WHERE id = NEW.collector_id) <> 1 THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose a courier to collect the order!'; 
  	END IF;
    IF NEW.curier_id >= 0 AND (SELECT w.work_type_id FROM workers w WHERE id = NEW.curier_id) <> 2 THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose a collector to deliver the order!'; 
  	END IF;
END//


-- Тест
-- курьер не может быть сборщиком
INSERT INTO orders (shop_id, user_id, users_addresses_id, user_payment_id, collector_id, curier_id, deliver_on) VALUES
   (1, 1, 2, 1, 2, 1, CURRENT_TIMESTAMP + INTERVAL 3 HOUR);
-- сборщик не может быть курьером
INSERT INTO orders (shop_id, user_id, users_addresses_id, user_payment_id, collector_id, curier_id, deliver_on) VALUES
   (1, 1, 2, 1, 3, 1, CURRENT_TIMESTAMP + INTERVAL 3 HOUR);  

  
  -- Триггеры на проверку/резервирование и списание товаров
/* Схема работы: 
 * 1. Проверка наличия в магазине достаточного количества товара для заказа
 * 2. Если есть достаточное количество, то перемещение из поля "в наличие" в поле "в заказах" в магазине - резервирование
 * 3. Если при начале сборки заказа (статус "собирается") произведена замена,
 *    то зарезервированный при заказе товар возвращается в запасы и резервируется товар, который был собран 
 * 4. Когда заказу выставляется статус "собран" в резерв проверяется и при отличии меняется нафактически собранное количество
 * 5. После выставления статуса "закрыт" зарезервированное количество товара списывается из поля "в заказах"
 * 6. В случае отмены заказа, т.е. при получении заказом статуса "отменен" продукция возвращается из поля "в заказах" в поле "в наличие" */
  

-- Триггер на проверку (при создании) достаточности количества товара в запасе магазина и его резервирование
DROP TRIGGER IF EXISTS quantity_order_check_and_reserv_insert;

DELIMITER //

CREATE TRIGGER quantity_order_check_and_reserv_insert
    BEFORE INSERT
    ON orders_goods FOR EACH ROW
BEGIN
	SET @ordered = NEW.quantity_in_order;
	IF NEW.quantity_in_order > (SELECT quantity FROM catalog WHERE id = NEW.catalog_id) THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose an amount more than in shop stock!';      
    ELSE
        UPDATE `catalog` SET quantity = quantity - @ordered WHERE id = NEW.catalog_id;
        UPDATE `catalog` SET in_orders = in_orders + @ordered WHERE id = NEW.catalog_id;
    END IF; 
END//

-- Тест
SELECT * FROM catalog WHERE id = 1;
SELECT * FROM orders_goods WHERE catalog_id = 1;
INSERT INTO orders_goods (order_id, catalog_id, quantity_in_order, quantity_collected, note) VALUES
   (3, 1, 200, 0, 'Товар id1 в заказе 3 TEST2');
  
-- Триггер на проверку (при обновлении) достаточности количества товара в запасе магазина и его резервирование
DROP TRIGGER IF EXISTS quantity_order_check_and_reserv_update;

DELIMITER //

CREATE TRIGGER quantity_order_check_and_reserv_update
    BEFORE UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
	SET @ordered = NEW.quantity_in_order - OLD.quantity_in_order;
	IF NEW.quantity_in_order > (SELECT quantity FROM catalog WHERE id = NEW.catalog_id) THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant choose an amount more than in shop stock!';      
    ELSE
        UPDATE `catalog` SET quantity = quantity - @ordered WHERE id = NEW.catalog_id;
        UPDATE `catalog` SET in_orders = in_orders + @ordered WHERE id = NEW.catalog_id;
    END IF; 
END//
  
-- Тест
SELECT * FROM catalog WHERE id = 1;
SELECT * FROM orders_goods WHERE catalog_id = 1;
UPDATE `orders_goods` SET quantity_in_order = 200 WHERE id = 1;


-- Триггер на пересчет запасов и резерва по факту сборки продукции без замены товара
DROP TRIGGER IF EXISTS order_position_collected_reserv_update;

DELIMITER //

CREATE TRIGGER order_position_collected_reserv_update
    BEFORE UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
	SET @ordered = OLD.quantity_in_order;
    SET @collected = OLD.quantity_collected;
    IF @ordered < @collected THEN
       SET @diff = @ordered - @collected;
	ELSE
	   SET @diff = 0;
    END IF;  
    IF NEW.position_staus = 1 AND (OLD.changed_catalog_id IS NULL OR OLD.changed_catalog_id = OLD.catalog_id) THEN
        UPDATE `catalog` SET quantity = quantity - @collected + @ordered WHERE id = NEW.catalog_id;
        UPDATE `catalog` SET in_orders = in_orders - @ordered + @diff WHERE id = NEW.catalog_id;
    END IF; 
END//


-- Тест
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 1; -- Позиция собирается
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 4; -- Позиция собирается
UPDATE `orders_goods` SET quantity_in_order = 7 WHERE id = 1; -- Заказано в заказе 1
UPDATE `orders_goods` SET quantity_in_order = 4 WHERE id = 4; -- Заказано в заказе 1
UPDATE `catalog` SET quantity = 69 WHERE id = 1;  -- изначальные запасы товара = 69 + 11
UPDATE `catalog` SET in_orders = 11 WHERE id = 1; -- товары в резерве по заказам
UPDATE `orders_goods` SET quantity_collected = 6 WHERE id = 1; -- резерв по заказу 1
UPDATE `orders_goods` SET quantity_collected = 4 WHERE id = 4; -- резерв по заказу 4
UPDATE `orders_goods` SET position_staus = 1 WHERE id = 1; -- Позиция собрана и закрыта
UPDATE `orders_goods` SET position_staus = 1 WHERE id = 4; -- Позиция собрана и закрыта

SELECT * FROM catalog WHERE id = 1;
SELECT * FROM orders_goods WHERE catalog_id = 1;



-- Триггер на пересчет запасов и резерва по факту сборки продукции с заменами товара
DROP TRIGGER IF EXISTS order_position_collected_with_changes_reserv_update;

DELIMITER //

CREATE TRIGGER order_position_collected_with_changes_reserv_update
    BEFORE UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
	SET @ordered = OLD.quantity_in_order;
    SET @collected = OLD.quantity_collected;
    IF @ordered < @collected THEN
       SET @diff = @ordered - @collected;
	ELSE
	   SET @diff = 0;
    END IF;  
    IF NEW.position_staus = 1 AND OLD.changed_catalog_id > 0 THEN
        -- ?????
        UPDATE `catalog` SET quantity = quantity - @collected WHERE id = OLD.changed_catalog_id;
        -- поле в резерве по заказам по данному товару не обновляем, т.к. изначально он не был в резерве
        UPDATE `catalog` SET quantity = quantity + @ordered WHERE id = NEW.catalog_id; -- возвращаем из резерва в запасы
        UPDATE `catalog` SET in_orders = in_orders - @ordered WHERE id = NEW.catalog_id; -- снимаем из резерва по заказам
    END IF; 
END//


-- Тест
UPDATE `orders` SET order_status  = 'Создан' WHERE id = 1;
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 1; -- Позиция собирается
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 4; -- Позиция собирается
UPDATE `orders_goods` SET quantity_in_order = 7 WHERE id = 1; -- Заказано в заказе 1
UPDATE `orders_goods` SET quantity_in_order = 4 WHERE id = 4; -- Заказано в заказе 1
UPDATE `catalog` SET quantity = 69 WHERE id = 1;  -- изначальные запасы товара 1 = 69 + 11
UPDATE `catalog` SET in_orders = 11 WHERE id = 1; -- товар 1 в резерве по заказам
UPDATE `catalog` SET quantity = 60 WHERE id = 2;  -- изначальные запасы товара 2
UPDATE `orders_goods` SET changed_catalog_id = 2 WHERE order_id = 1 AND catalog_id = 1; -- замена товара 1 на 2
UPDATE `orders_goods` SET quantity_collected = 6 WHERE id = 1; -- резерв по заказу 1
UPDATE `orders_goods` SET quantity_collected = 4 WHERE id = 4; -- резерв по заказу 4
UPDATE `orders_goods` SET position_staus = 1 WHERE id = 1; -- Позиция собрана и закрыта
UPDATE `orders_goods` SET position_staus = 1 WHERE id = 4; -- Позиция собрана и закрыта

SELECT * FROM catalog WHERE id in (1, 2);
SELECT * FROM orders_goods WHERE catalog_id in (1, 2);




-- Триггер на проверку изменения закрытого заказа
DROP TRIGGER IF EXISTS order_closed_change_test_update;

DELIMITER //

CREATE TRIGGER order_closed_change_test_update
    BEFORE UPDATE
    ON orders_goods FOR EACH ROW
BEGIN
    IF (SELECT order_status FROM orders WHERE id = OLD.order_id) = 'Закрыт' THEN
    	SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You cant do changes in closed order!'; 
  	END IF; 
END//


-- Тест 
UPDATE `orders` SET order_status  = 'Создан' WHERE id = 1; -- Выставляем статус заказа Создан
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 1; -- Позиция собирается
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 4; -- Позиция собирается
UPDATE `orders_goods` SET quantity_in_order = 7 WHERE id = 1; -- Заказано в заказе 1
UPDATE `orders_goods` SET quantity_in_order = 4 WHERE id = 4; -- Заказано в заказе 1
UPDATE `catalog` SET quantity = 69 WHERE id = 1;  -- изначальные запасы товара 1 = 69 + 11
UPDATE `catalog` SET in_orders = 11 WHERE id = 1; -- товар 1 в резерве по заказам
UPDATE `catalog` SET quantity = 60 WHERE id = 2;  -- изначальные запасы товара 2
UPDATE `orders` SET order_status  = 'Закрыт' WHERE id = 1; -- Закрываем заказ
UPDATE `orders_goods` SET quantity_in_order = 7 WHERE id = 1;
UPDATE `orders_goods` SET position_staus = 0 WHERE id = 1;
UPDATE `orders_goods` SET quantity_collected = 6 WHERE id = 1;

SELECT * FROM orders WHERE id = 1;


SHOW triggers
