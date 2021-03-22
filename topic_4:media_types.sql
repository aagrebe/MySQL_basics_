
/* Практическое задание #4. */

/* Задание # 3.
 * Написать запрос для переименования названий типов медиа (колонка name в media_types) 
 * в осмысленные для полученного дампа с данными (например, в "фото", "видео", ...)
*/

USE vk;

SHOW tables;

SELECT * FROM media_types;

UPDATE media_types
	SET name = CASE id
		WHEN 1 THEN 'foto'
		WHEN 2 THEN 'video'
		WHEN 3 THEN 'audio'
		WHEN 4 THEN 'document'
END
WHERE id IN (1,2,3,4);

SELECT * FROM media_types;