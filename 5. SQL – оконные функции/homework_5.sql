SELECT * FROM profiles;
/* users(id, firstname, lastname, email)
   profiles(user_id, gender, birthday, photo_id, hometown)
   likes(id, user_id, media_id)
   media(id, user_id, media_type_id, body, filename, created_at, update_at)
   media_types(id, name_type)
   messages(id, from_user_id, to_user_id, body, created_at)
   friend_requests(initiator_user_id, target_user_id, status, requested_at, updated_at)
   users_communities(user_id, community_id)
   communities(id, name) */
/* 1. Создайте представление, в которое попадет информация 
о пользователях (имя, фамилия, город и пол), которые не
 старше 20 лет. */
CREATE OR REPLACE VIEW person AS
SELECT CONCAT(u.firstname, " ", u.lastname) AS "Full name", p.hometown, p.gender
FROM users u JOIN profiles p ON u.id = p.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 20;
SELECT * FROM person;

/* 2. Найдите кол-во, отправленных сообщений каждым 
пользователем и выведите ранжированный список пользователей, 
указав имя и фамилию пользователя, количество отправленных 
сообщений и место в рейтинге (первое место у пользователя с 
максимальным количеством сообщений) . (используйте DENSE_RANK) */
SELECT DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS "Rank",
	COUNT(*) AS "Count",
    CONCAT(u.firstname, " ",lastname)
FROM messages m 
	JOIN users u ON m.from_user_id = u.id
GROUP BY u.id
ORDER BY "Rank";

/* 3. Выберите все сообщения, отсортируйте сообщения по 
возрастанию даты отправления (created_at) и найдите разницу 
дат отправления между соседними сообщениями, получившегося 
списка. (используйте LEAD или LAG) */
SELECT created_at,
       LAG(created_at) OVER (ORDER BY created_at)                                    AS prev_created_at,
       TIMESTAMPDIFF(SECOND, LAG(created_at) OVER (ORDER BY created_at), created_at) AS time_diff
FROM messages
ORDER BY created_at;