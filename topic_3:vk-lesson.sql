
/* Практическое задание #3. */

/* Задание # 1.
 * Проанализировать структуру БД vk с помощью скрипта, который мы создали на занятии (vk-lesson.sql), 
 * и внести предложения по усовершенствованию (если такие идеи есть). Создайте у себя БД vk с помощью скрипта 
 * из материалов урока. Напишите пожалуйста, всё ли понятно по структуре. Примечание: vk-lesson.sql - скрипт, 
 * который мы писали на уроке, vk.sql - дамп таблицы vk.
 * Для удобства изменения буду комментировать через РЕШЕТКУ
*/

DROP DATABASE IF EXISTS vk;

CREATE DATABASE vk;

USE vk;

SHOW tables;

CREATE TABLE users ( 
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(145) NOT NULL, -- "Имя"
  last_name VARCHAR(145) NOT NULL,
  email VARCHAR(145) NOT NULL,
  phone INT UNSIGNED NOT NULL,
  password_hash CHAR(65) DEFAULT NULL, -- dfghjkkhf -> hash -> catmew
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- now()
  UNIQUE INDEX email_unique (email),
  UNIQUE INDEX phone_unique (phone)
) ENGINE=InnoDB;


CREATE TABLE language_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(25) NOT NULL # название языка
) ENGINE=InnoDB;

#ALTER TABLE users ADD COLUMN user_language language_types_name ???; # добавляем колонку языка

SELECT * FROM users;

DESCRIBE users; -- описание таблицы

-- 1:1 связь один к одному
CREATE TABLE profiles (
  user_id BIGINT UNSIGNED NOT NULL,
  gender ENUM('female', 'male'), # vk предлагает только два варианта
  birthday DATE NOT NULL,
  photo_id VARCHAR(30),
  user_status VARCHAR(30),
  city VARCHAR(130),
  country VARCHAR (130),
  UNIQUE INDEX fk_profiles_users_to_idx (user_id),
  CONSTRAINT fk_profiles_users FOREIGN KEY (user_id) REFERENCES users (id) -- связь таблички профилей и пользователей
  -- ON DELETE CASCADE - удалить профиль вместе с пользователем
);

-- n:m связь от многих к многим

CREATE TABLE messages (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
  from_user_id BIGINT UNSIGNED NOT NULL, -- id = 1, Вася
  to_user_id BIGINT UNSIGNED NOT NULL, -- id = 2, Петя
  txt TEXT NOT NULL, -- txt = ПРИВЕТ
  is_delivered BOOLEAN DEFAULT False,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- NOW()
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
  INDEX fk_messages_from_user_idx (from_user_id),
  INDEX fk_messages_to_user_idx (to_user_id),
  CONSTRAINT fk_messages_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_messages_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);


DESCRIBE messages;

-- n:m связь от многих к многим

CREATE TABLE friend_requests (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- 1
  from_user_id BIGINT UNSIGNED NOT NULL, -- id = 1, Вася
  to_user_id BIGINT UNSIGNED NOT NULL, -- id = 2, Петя
  accepted BOOLEAN DEFAULT False,
  INDEX fk_friend_requests_from_user_idx (from_user_id),
  INDEX fk_friend_requests_to_user_idx (to_user_id),
  CONSTRAINT fk_friend_requests_users_1 FOREIGN KEY (from_user_id) REFERENCES users (id),
  CONSTRAINT fk_friend_requests_users_2 FOREIGN KEY (to_user_id) REFERENCES users (id)
);

CREATE TABLE communities (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(145) NOT NULL,
  description VARCHAR(245) DEFAULT NULL,
  admin_id BIGINT UNSIGNED NOT NULL,
  INDEX fk_communities_users_admin_idx (admin_id),
  CONSTRAINT fk_communities_users FOREIGN KEY (admin_id) REFERENCES users (id)
) ENGINE=InnoDB;

-- n:m

-- Таблица связи пользователей и сообществ
CREATE TABLE communities_users (
  community_id BIGINT UNSIGNED NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, 
  PRIMARY KEY (community_id, user_id),
  INDEX fk_communities_users_comm_idx (community_id),
  INDEX fk_communities_users_users_idx (user_id),
  CONSTRAINT fk_communities_users_comm FOREIGN KEY (community_id) REFERENCES communities (id),
  CONSTRAINT fk_communities_users_users FOREIGN KEY (user_id) REFERENCES users (id)
) ENGINE=InnoDB;


CREATE TABLE media_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name varchar(45) NOT NULL -- фото, музыка, документы
) ENGINE=InnoDB;


-- 1:n

CREATE TABLE media (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- Картинка 1
  user_id BIGINT UNSIGNED NOT NULL,
  media_types_id INT UNSIGNED NOT NULL, -- фото
  file_name VARCHAR(245) DEFAULT NULL COMMENT '/files/folder/img.png',
  file_size BIGINT DEFAULT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX fk_media_media_types_idx (media_types_id),
  INDEX fk_media_users_idx (user_id),
  CONSTRAINT fk_media_media_types FOREIGN KEY (media_types_id) REFERENCES media_types (id),
  CONSTRAINT fk_media_users FOREIGN KEY (user_id) REFERENCES users (id)
);


