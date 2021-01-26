USE vk;

-- Переписать запросы, заданные к ПЗ урока 6 с использованием JOIN
     
/* Задание 3. 
 * Определить кто больше поставил лайков (всего) - мужчины или женщины? */

-- результат
SELECT 
	COUNT(*) AS total,
	(SELECT gender FROM gender WHERE id = p.gender_id) as gender
FROM likes l
LEFT JOIN profiles p
ON l.user_id = p.user_id
GROUP BY gender
ORDER BY total DESC
LIMIT 1;

 

/* Задание 4.
 * Подсчитать количество лайков которые получили 10 самых молодых пользователей. */

    -- результат
 SELECT CONCAT(p.first_name, ' ', p.last_name) name, p.birthday birthday, COUNT(*) likes
   FROM likes l
   JOIN users u on u.id = l.user_id
   JOIN profiles p on p.user_id = l.user_id
   GROUP BY name, birthday 
   ORDER BY birthday DESC
   LIMIT 10;
  

/* Задание 5. 
 * Найти 10 пользователей, которые проявляют наименьшую активность в
 *  использовании социальной сети (критерии активности необходимо определить самостоятельно). */

-- результат
SELECT CONCAT(p.first_name, ' ', p.last_name) name, 
	COUNT(l.id) + COUNT(m.id) + COUNT(md.id) + COUNT(ps.id) activity
FROM profiles p
	LEFT JOIN likes l ON l.user_id = p.user_id
	LEFT JOIN messages m ON m.from_user_id = p.user_id
	LEFT JOIN media md ON md.user_id = p.user_id
	LEFT JOIN posts ps ON ps.user_id = p.user_id
	LEFT JOIN users u ON p.user_id = u.id
GROUP BY name
ORDER BY activity
LIMIT 10;
