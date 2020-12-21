/* Возможные улучшения базы
1. Поле пол можно вынести в отдельный справочник для того, чтобы возможные варианты были заданы не программно, а выбирались из БД.
По 1 символу не всегда можно понять что за пол подразумевается https://subscribe.ru/group/razumno-o-svoem-i-nabolevshem/6678982/
Это также будет удобней для построения запросов, т.к., если нет доступа к программной обололочке, то для понимания возможных вариантов пола
 не будет необходимости перебрать всю базу и выбирать уникальные значения по данному полю. */
 
-- Таблица профилей
CREATE TABLE profiles (
  user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT "Ссылка на пользователя", 
  gender_id INT NOT NULL COMMENT "Ссылка на пол",
  birthday DATE COMMENT "Дата рождения",
  photo_id INT UNSIGNED COMMENT "Ссылка на основную фотографию пользователя",
  status VARCHAR(30) COMMENT "Текущий статус",
  city VARCHAR(130) COMMENT "Город проживания",
  country VARCHAR(130) COMMENT "Страна проживания",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Профили"; 

-- Справочник полов
CREATE TABLE gender (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT "Идентификатор строки", 
  gender VARCHAR(25) COMMENT "Название пола",
  gender_info VARCHAR(150) COMMENT "Информация о поле",
  active BOOLEAN COMMENT "Активен/Неактивен. Доступность для выбора",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки"
) COMMENT "Варианты полов";



/*2. Можно избавиться от возможной избыточности в таблице frienship, когда и первый и второй пользователь отпраявят запрос на дружбу
 друг другу.
*/
 
-- Таблица дружбы
CREATE TABLE friendship (
  user_id INT UNSIGNED NOT NULL COMMENT "Ссылка на инициатора дружеских отношений",
  friend_id INT UNSIGNED NOT NULL COMMENT "Ссылка на получателя приглашения дружить",
  status_id INT UNSIGNED NOT NULL COMMENT "Ссылка на статус (текущее состояние) отношений",
  requested_at DATETIME DEFAULT NOW() COMMENT "Время отправления приглашения дружить",
  confirmed_at DATETIME COMMENT "Время подтверждения приглашения",
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT "Время создания строки",  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",  
  CONSTRAINT Friends_user_id_friend_id PRIMARY KEY (user_id, friend_id) COMMENT "Составной первичный ключ",
  CONSTRAINT Friends_friend_id_user_id UNIQUE (friend_id, user_id) COMMENT "Дополнительное ограничение для уникальности дружеских отношений",
) COMMENT "Таблица дружбы";
