USE vk;


/* Задание 1. Внесение изменений в базу vk*/

DROP TABLE IF EXISTS contacts;
CREATE TABLE contacts (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор сроки',
  `user_id` int unsigned NOT NULL COMMENT 'Ссылка на профиль пользователя',
  `contact_type` varchar(30) DEFAULT NULL COMMENT 'Тип контакта',
  `contact_info` varchar(1000) DEFAULT NULL COMMENT 'контактная информация',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`)
  ) COMMENT 'Контактная информация';
  
 
ALTER TABLE profiles
 ADD first_name varchar(100) NOT NULL COMMENT 'Имя пользователя' AFTER country,
 ADD last_name varchar(100) NOT NULL COMMENT 'Фамилия пользователя' AFTER first_name;
 

DROP TABLE IF EXISTS gender;
CREATE TABLE gender (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  gender VARCHAR(25) COMMENT "Название пола",
  gender_info VARCHAR(150) COMMENT "Информация о поле",
  active BOOLEAN COMMENT "Активен/Неактивен. Доступность для выбора",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Варианты полов";

ALTER TABLE profiles
 ADD gender_id int NOT NULL COMMENT 'Ссылка на пол' AFTER gender;


DROP TABLE IF EXISTS `user_statuses`;
CREATE TABLE `user_statuses` (
  `id` int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
  `name` varchar(100) NOT NULL COMMENT 'Название статуса (уникально)',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Варианты статусов';

INSERT INTO gender (gender, gender_info, active) VALUES
 ('Мужской', 'Мужской пол', TRUE),
 ('Женский', 'Женский пол', TRUE);


/* DROP TABLE IF EXISTS `media_types`;
CREATE TABLE `media_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT 'Идентификатор строки',
  `name` varchar(255) NOT NULL COMMENT 'Название типа',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) COMMENT='Типы медиафайлов';

INSERT INTO media_types (name) VALUES
 ('Video'),
 ('Audio'),
 ('Image');*/

UPDATE profiles SET updated_at = CURRENT_TIMESTAMP() WHERE updated_at < created_at;

INSERT INTO user_statuses (name) VALUES
 ('single'),
 ('married');

UPDATE profiles SET status = NULL;
ALTER TABLE profiles RENAME COLUMN status to user_status_id;
ALTER TABLE profiles MODIFY COLUMN user_status_id INT UNSIGNED;

DESCRIBE profiles;

UPDATE profiles SET gender_id = (SELECT id FROM gender ORDER BY rand() LIMIT 1);
ALTER TABLE profiles DROP COLUMN gender;

UPDATE profiles SET user_status_id = floor(1 + RAND()*2);

UPDATE profiles p SET p.first_name = 
(SELECT u.first_name FROM users u WHERE u.id = p.user_id);

UPDATE profiles p SET p.last_name = 
(SELECT u.last_name FROM users u WHERE u.id = p.user_id);

ALTER TABLE users DROP COLUMN first_name, DROP COLUMN last_name;


INSERT INTO contacts (user_id, contact_type, contact_info)
SELECT id, 'email', email FROM users
UNION ALL
SELECT id, 'phone', phone FROM users;

UPDATE media SET media_type_id = 0;
UPDATE media SET media_type_id = (SELECT id FROM media_types ORDER BY rand() LIMIT 1);

SELECT * FROM messages WHERE from_user_id = to_user_id;

SELECT id FROM media WHERE media_type_id = (SELECT id FROM media_types WHERE name = 'Image');

UPDATE profiles SET photo_id = 
 (SELECT id FROM media WHERE media_type_id = 
  (SELECT id FROM media_types WHERE name = 'Image')
 ORDER BY rand() LIMIT 1
);

SELECT * FROM friendship where user_id = friend_id;

-- Доп. задача генерация размера медиафайлов
UPDATE media m SET m.size = floor(50*(RAND()*50)+(RAND()*100));

/*  Доп. задача 3. Проектирование структуры базы для лайков и постов
Лайки постов это достаточно узкий функционал, поэтому лучше на перспективу проектировать систему реакий
 на посты посредством различных эмоджи, комментариев постов, а также тэгов постов.
*/

DROP TABLE IF EXISTS `emodji`;	
CREATE TABLE `emodji` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор эмоджи',
  `name` VARCHAR(30) NULL DEFAULT NULL COMMENT 'Название эмоджи',
  `image_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на изображение эмоджи',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Виды эмоджи';


DROP TABLE IF EXISTS `tags`;	
CREATE TABLE `tags` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор тэга',
  `name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Тэг',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Виды тэгов';


DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор поста',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
  `title` VARCHAR(150) NOT NULL COMMENT 'Заголовок поста',
  `content` VARCHAR(1000) NOT NULL COMMENT 'Содержание поста',
  `is_active` TINYINT(1) NOT NULL DEFAULT TRUE COMMENT 'Активен/неактивен. Доступность для просмотра',
  `views` INT UNSIGNED COMMENT 'Счетчик количества просмотров поста',
  `reposts` INT UNSIGNED COMMENT 'Счетчик количества репостов',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',  
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Посты';


DROP TABLE IF EXISTS `post_tags`;	
CREATE TABLE `post_tags` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор тэга поста',
  `tag_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на тэг',
  `post_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на пост',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки'
) COMMENT 'Тэги постов';


DROP TABLE IF EXISTS `post_reactions`;	
CREATE TABLE `post_reactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор реакции на пост',
  `emoji_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на эмоджи',
  `post_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на пост',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки' 
) COMMENT 'Реакции на посты';


DROP TABLE IF EXISTS `post_comments`;	
CREATE TABLE `post_comments` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор комментария поста',
  `user_id` INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
  `post_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на пост',
  `content` VARCHAR(250) NOT NULL COMMENT 'Содержание комментария',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Комментарии постов';


DROP TABLE IF EXISTS `comment_reactions`;	
CREATE TABLE `comment_reactions` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор реакции на комментарий поста',
  `emoji_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на эмоджи',
  `comment_id` INT UNSIGNED DEFAULT NULL COMMENT 'Ссылка на комментарий',
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки', 
) COMMENT 'Реакции на комментарии к постам';
