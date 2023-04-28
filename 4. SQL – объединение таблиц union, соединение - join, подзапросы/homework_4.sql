/* 1. Подсчитать общее количество лайков, 
которые получили пользователи младше 12 лет. */
SELECT COUNT(*) AS 'Like 12-'
FROM likes
	JOIN profiles ON likes.user_id = profiles.user_id
WHERE TIMESTAMPDIFF(YEAR, profiles.birthday, CURDATE()) < 12;

/* 2. Определить кто больше поставил лайков 
(всего): мужчины или женщины. */
SELECT p.gender, COUNT(*) AS 'Like'
FROM likes l
	JOIN profiles p ON l.user_id = p.user_id
GROUP BY p.gender
ORDER BY COUNT(*) DESC LIMIT 1;

/* 3. Вывести всех пользователей, которые не 
отправляли сообщения. */
SELECT u.id, CONCAT(u.firstname, " ", u.lastname) AS "Not send"
FROM users u
	JOIN messages m ON u.id = m.from_user_id
WHERE m.from_user_id = NULL;

/* 4. (по желанию)* Пусть задан некоторый пользователь. 
Из всех друзей этого пользователя найдите человека, 
который больше всех написал ему сообщений. */
select * from friend_requests;
SELECT * FROM friend_requests fr
WHERE (initiator_user_id = 1 OR target_user_id = 1) 
	AND status = 'approved';

SELECT initiator_user_id AS id FROM fr
WHERE target_user_id = 1
	AND status = 'approved'
UNION
SELECT target_user_id FROM fr
WHERE initiator_user_id = 1
	AND status = 'approved';