/* Задание 1
 * Проанализировать, какие запросы могут выполняться наиболее
часто в процессе работы приложения, и добавить необходимые индексы. */

-- Запросы к таблице gender к полю gender при выводе информации при создании/поиске пользователей
CREATE UNIQUE INDEX gender_gender_idx ON gender(gender);

-- Запросы к таблице profiles к полям country и city при поиске/фильтрации профилей пользователей
CREATE INDEX profiles_country_city_idx ON profiles(country, city);

-- Запросы к таблице posts к полю created_at при поиске/формировании выдачи постов за определенный период
CREATE INDEX posts_created_at_idx ON posts(created_at);

-- Запросы к таблице messages к полю created_at при поиске/формировании выдачи сообщений за определенный период
CREATE INDEX messages_created_at_idx ON messages(created_at);

-- Запросы к таблице communities к полю name при поиске/формировании выдачи групп
CREATE INDEX communities_name_idx ON communities(name);

-- Остальные возможные поля для индексирования либо являются первичными ключами, либо имеют очень небольшое количество записей



/* Задание 2
 * Задание на оконные функции. Построить запрос, который будет выводить следующие столбцы:
 - имя группы
 - среднее количество пользователей в группах
 - самый молодой пользователь в группе
 - самый старший пользователь в группе
 - общее количество пользователей в группе
 - всего пользователей в системе
 - отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100 */

-- результат
USE vk;

SELECT DISTINCT
  c.name,
  COUNT(cu.user_id) OVER () / (SELECT COUNT(*) FROM communities) AS avg_size,
  MAX(p.birthday) OVER w AS youngest,
  MIN(p.birthday) OVER w AS oldest,
  COUNT(cu.user_id) OVER w AS group_size,
  COUNT(cu.user_id) OVER() AS total_users,
  COUNT(cu.user_id) OVER w / COUNT(p.user_id) OVER() * 100 AS "%"
FROM communities_users cu
JOIN communities c ON c.id = cu.community_id
JOIN profiles p ON p.user_id = cu.user_id
WINDOW w AS (PARTITION BY cu.community_id)
ORDER BY name
