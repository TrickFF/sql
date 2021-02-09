-- Запрос на получение цен по товару во всех магазинах
SELECT 
  (SELECT CONCAT(city,' ', street, ' ', building) FROM shops WHERE shop_id = id) AS shop,
  (SELECT name FROM goods WHERE goods_id = id) AS position,
  price AS price,
  (SELECT price - price * 0.15) AS discont_price,
  quantity,
  note
FROM catalog WHERE goods_id = 3;


-- Запрос на получение цен по всем товарам магазина
SELECT 
  (SELECT CONCAT(city, ' ', street, ' ', building) FROM shops WHERE shop_id = id) AS shop,
  (SELECT name FROM goods WHERE goods_id = id) AS position,
  price AS price,
  (SELECT price - price * 0.15) AS discont_price,
  quantity,
  note
FROM catalog WHERE shop_id = 1;


-- Запрос на вывод количаства исполнителей работ, закрепленных за магазинами
SELECT 
   CONCAT(b.name, ' - ', city,' ', street, ' ', building) AS shop,
   COUNT(DISTINCT w.id) AS collectors,
   COUNT(DISTINCT wr.id) AS couriers
FROM shops s
   LEFT JOIN workers w ON w.work_type_id = 1 AND s.id = w.shop_id
   LEFT JOIN workers wr ON wr.work_type_id = 2 AND s.id = wr.shop_id
   JOIN brands b on s.brand_id = b.id
GROUP BY shop;

-- Представление количаства исполнителей работ, закрепленных за магазинами
CREATE VIEW shop_workers AS
SELECT 
   CONCAT(b.name, ' - ', city,' ', street, ' ', building) AS shop,
   COUNT(DISTINCT w.id) AS collectors,
   COUNT(DISTINCT wr.id) AS couriers
FROM shops s
   LEFT JOIN workers w ON w.work_type_id = 1 AND s.id = w.shop_id
   LEFT JOIN workers wr ON wr.work_type_id = 2 AND s.id = wr.shop_id
   JOIN brands b on s.brand_id = b.id
GROUP BY shop;

SELECT * FROM shop_workers;


-- Запрос на подсчет стоимости и веса заказанных позиций в заказе с учетом замен
SELECT 
  g.name AS goods,
  og.catalog_id,
  og.changed_catalog_id,
  og.quantity_in_order,
  og.quantity_collected,
  c.price,
  (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) AS change_price,
  g.weight,
  (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) AS change_weight,
  c.price * og.quantity_in_order AS position_price,
  (SELECT case when change_price IS NULL
     then price * quantity_collected
     else change_price * quantity_collected END
     FROM orders_goods WHERE id = og.id) AS fact_position_price,
  (SELECT case when change_weight IS NULL
     then weight * quantity_collected
     else change_weight * quantity_collected END
     FROM orders_goods WHERE id = og.id) AS position_weight
FROM orders_goods og
JOIN goods g ON g.id = catalog_id
JOIN catalog c ON c.id = catalog_id
WHERE order_id = 1;


-- Запрос на предварительный расчетной стоимости заказа до его сборки
SELECT 
   order_id,
   SUM(c.price * og.quantity_in_order) AS order_price FROM orders_goods og JOIN catalog c ON c.id = og.catalog_id WHERE og.order_id = 1;

-- Запрос на подсчет фактической стоимости заказа
SELECT
  order_id,
  SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_price_fact 
FROM orders_goods og
JOIN catalog c ON c.id = catalog_id
WHERE order_id = 1;


-- Запрос на подсчет фактической стоимости, веса заказа и ориентировочного количества пакетов (8кг без учета объема товара) для его доставки с округлением до целого в большую сторону
SELECT
  order_id,
  SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_price,
  SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_weight,
  CEILING(SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) / 8) AS packs
FROM orders_goods og
JOIN goods g ON g.id = catalog_id
JOIN catalog c ON c.id = catalog_id
WHERE order_id = 1;

-- Представление расчета фактической стоимости, веса заказа и ориентировочного количества пакетов (8кг без учета объема товара) для его доставки с округлением до целого в большую сторону
CREATE VIEW order_price_weight AS
SELECT
  order_id,
  SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_price,
  SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_weight,
  CEILING(SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) / 8) AS packs
FROM orders_goods og
JOIN goods g ON g.id = catalog_id
JOIN catalog c ON c.id = catalog_id
WHERE order_id = 1;

SELECT * FROM order_price_weight;

-- Запрос на расчет стоимости заказа с учетом стоимости сборки и доставки в зависимости от суммы заказа
/* Сборка 99 руб, при заказе от 2500 руб. сборка бесплатно
Стоимость доставки всегда 249 руб.
Стоимость пакетов всегда 14 руб.
От 30 кг доплата за вес 50 руб
При весе заказа от 40кг - доплата 150 руб. */
SELECT
  order_id,
  SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_price,
  SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) AS order_weight,
  CEILING(SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) / 8) AS packs,
  14 AS packs_price,
  (SELECT case when SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) < 2500 then 49 ELSE 0 END) AS collecting_price,
   (SELECT case when SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) > 50 then 150 when SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) > 30 then 50 else 0 end) AS weight_payment,
   (SELECT SUM(SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) + packs_price + (SELECT case when SUM((SELECT case when (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) IS NULL
     then price * quantity_collected
     else (SELECT c.price FROM catalog c WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) < 2500 then 49 ELSE 0 END) + (SELECT case when SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) > 50 then 150 when SUM((SELECT case when (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) IS NULL
     then weight * quantity_collected
     else (SELECT g.weight FROM goods g WHERE id = og.changed_catalog_id) * quantity_collected END
     FROM orders_goods WHERE id = og.id)) > 30 then 50 else 0 end))) + 249 AS total_order_price
FROM orders_goods og
JOIN goods g ON g.id = catalog_id
JOIN catalog c ON c.id = catalog_id
WHERE order_id = 1;
