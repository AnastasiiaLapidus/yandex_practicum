-- Найдите количество вопросов, которые набрали больше 300 очков 
-- или как минимум 100 раз были добавлены в «Закладки».

SELECT COUNT(*)
FROM stackoverflow.posts AS p
LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
WHERE pt.type = 'Question'
  AND (score > 300
       OR favorites_count >= 100);



-- Сколько в среднем в день задавали вопросов с 1 по 18 ноября 2008 включительно? 
-- Результат округлите до целого числа.

SELECT ROUND(AVG(num_questions))
FROM
  (SELECT COUNT(p.title) AS num_questions
   FROM stackoverflow.posts AS p
   LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
   WHERE pt.type = 'Question'
     AND CAST(DATE_TRUNC('DAY', p.creation_date) AS date) BETWEEN '2008-11-01' AND '2008-11-18'
   GROUP BY DATE_TRUNC('DAY', p.creation_date)) AS questions_per_day;



-- Сколько пользователей получили значки сразу в день регистрации? 
-- Выведите количество уникальных пользователей.

SELECT COUNT(DISTINCT(u.id))
FROM stackoverflow.users AS u
LEFT JOIN stackoverflow.badges AS b ON u.id = b.user_id
WHERE CAST(DATE_TRUNC('DAY', u.creation_date) AS date) = CAST(DATE_TRUNC('DAY', b.creation_date) AS date);



-- Сколько уникальных постов пользователя с именем Joel Coehoorn получили хотя бы один голос?

SELECT COUNT (DISTINCT p.id)
FROM stackoverflow.posts AS p
LEFT JOIN stackoverflow.users AS u ON p.user_id = u.id
LEFT JOIN stackoverflow.votes AS v ON p.id = v.post_id
WHERE display_name = 'Joel Coehoorn'
  AND post_id IS NOT NULL;



-- Выгрузите все поля таблицы vote_types. Добавьте к таблице поле rank, 
-- в которое войдут номера записей в обратном порядке. 
-- Таблица должна быть отсортирована по полю id.

SELECT *,
       ROW_NUMBER() OVER(
                         ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;



-- Отберите 10 пользователей, которые поставили больше всего голосов типа Close. 
-- Отобразите таблицу из двух полей: идентификатором пользователя и количеством голосов. 
-- Отсортируйте данные сначала по убыванию количества голосов, 
-- потом по убыванию значения идентификатора пользователя.

SELECT u.id,
       COUNT(vt.id) AS COUNT
FROM stackoverflow.users AS u
LEFT JOIN stackoverflow.votes AS v ON u.id = v.user_id
LEFT JOIN stackoverflow.vote_types AS vt ON v.vote_type_id = vt.id
WHERE vt.name = 'Close'
GROUP BY u.id
ORDER BY COUNT DESC
LIMIT 10;



-- Отберите 10 пользователей по количеству значков, 
-- полученных в период с 15 ноября по 15 декабря 2008 года включительно.
-- Отобразите несколько полей:
-- 1. идентификатор пользователя;
-- 2. число значков;
-- 3. место в рейтинге — чем больше значков, тем выше рейтинг.
-- Пользователям, которые набрали одинаковое количество значков, присвойте одно и то же место в рейтинге.
-- Отсортируйте записи по количеству значков по убыванию, 
-- а затем по возрастанию значения идентификатора пользователя.

SELECT id,
       COUNT,
       DENSE_RANK() OVER(
                         ORDER BY COUNT DESC) AS rank
FROM
  (SELECT u.id,
          COUNT(b.id) AS COUNT
   FROM stackoverflow.users AS u
   LEFT JOIN stackoverflow.badges AS b ON u.id = b.user_id
   WHERE CAST(DATE_TRUNC('DAY', b.creation_date) AS date) BETWEEN '2008-11-15' AND '2008-12-15'
   GROUP BY u.id
   ORDER BY COUNT DESC
   LIMIT 10) AS i
ORDER BY rank,
         id;



-- Сколько в среднем очков получает пост каждого пользователя?
-- Сформируйте таблицу из следующих полей:
-- 1. заголовок поста;
-- 2. идентификатор пользователя;
-- 3. число очков поста;
-- 4. среднее число очков пользователя за пост, округлённое до целого числа.
-- Не учитывайте посты без заголовка, а также те, что набрали ноль очков.

SELECT p.title,
       p.user_id,
       p.score,
       ROUND(AVG(p.score) OVER (PARTITION BY p.user_id))
FROM stackoverflow.posts AS p
WHERE p.title IS NOT NULL
  AND score != 0;



-- Отобразите заголовки постов, которые были написаны пользователями, 
-- получившими более 1000 значков. Посты без заголовков не должны попасть в список.

SELECT title
FROM stackoverflow.posts
WHERE title IS NOT NULL
  AND user_id IN
    (SELECT id
     FROM
       (SELECT u.id,
               COUNT(b.id) AS COUNT
        FROM stackoverflow.users AS u
        LEFT JOIN stackoverflow.badges AS b ON u.id = b.user_id
        GROUP BY u.id) AS i
     WHERE COUNT > 1000);



-- Напишите запрос, который выгрузит данные о пользователях из Канады (англ. Canada).
-- Разделите пользователей на три группы в зависимости от количества просмотров их профилей:
-- 1. пользователям с числом просмотров больше либо равным 350 присвойте группу 1;
-- 2. пользователям с числом просмотров меньше 350, но больше либо равно 100 — группу 2;
-- 3. пользователям с числом просмотров меньше 100 — группу 3.
-- Отобразите в итоговой таблице идентификатор пользователя, количество просмотров профиля и группу. 
-- Пользователи с количеством просмотров меньше либо равным нулю не должны войти в итоговую таблицу.

SELECT id,
       VIEWS,
       CASE
           WHEN VIEWS >= 350 THEN 1
           WHEN VIEWS >= 100
                AND VIEWS < 350 THEN 2
           WHEN VIEWS < 100 THEN 3
       END
FROM stackoverflow.users
WHERE LOCATION LIKE '%Canada%'
  AND VIEWS > 0;



-- Дополните предыдущий запрос. Отобразите лидеров каждой группы — пользователей, 
-- которые набрали максимальное число просмотров в своей группе. 
-- Выведите поля с идентификатором пользователя, группой и количеством просмотров. 
-- Отсортируйте таблицу по убыванию просмотров, а затем по возрастанию значения идентификатора.

SELECT u.id,
       CASE
           WHEN u.views >= 350 THEN 1
           WHEN u.views >= 100
                AND u.views < 350 THEN 2
           WHEN u.views < 100 THEN 3
       END AS case_value,
       u.views
FROM stackoverflow.users AS u
WHERE u.id IN
    (SELECT id
     FROM
       (SELECT id,
               VIEWS,
               CASE
                   WHEN VIEWS >= 350 THEN 1
                   WHEN VIEWS >= 100
                        AND VIEWS < 350 THEN 2
                   WHEN VIEWS < 100 THEN 3
               END AS case_value
        FROM stackoverflow.users
        WHERE LOCATION LIKE '%Canada%'
          AND VIEWS > 0) AS i
     WHERE (case_value,
            VIEWS) IN
         (SELECT case_value,
                 MAX(VIEWS) AS MAX
          FROM
            (SELECT id,
                    VIEWS,
                    CASE
                        WHEN VIEWS >= 350 THEN 1
                        WHEN VIEWS >= 100
                             AND VIEWS < 350 THEN 2
                        WHEN VIEWS < 100 THEN 3
                    END AS case_value
             FROM stackoverflow.users
             WHERE LOCATION LIKE '%Canada%'
               AND VIEWS > 0) AS j
          GROUP BY case_value))
ORDER BY VIEWS DESC, id;



-- Посчитайте ежедневный прирост новых пользователей в ноябре 2008 года. 
-- Сформируйте таблицу с полями:
-- 1. номер дня;
-- 2. число пользователей, зарегистрированных в этот день;
-- 3. сумму пользователей с накоплением.

SELECT *,
       SUM(day_count) OVER(
                           ORDER BY the_day)
FROM
  (SELECT EXTRACT(DAY
                  FROM creation_date) AS the_day,
          COUNT(id) AS day_count
   FROM stackoverflow.users
   WHERE EXTRACT(MONTH
                 FROM creation_date) = 11
     AND EXTRACT(YEAR
                 FROM creation_date) = 2008
   GROUP BY the_day) AS i;



-- Для каждого пользователя, который написал хотя бы один пост, 
-- найдите интервал между регистрацией и временем создания первого поста. Отобразите:
-- 1. идентификатор пользователя;
-- 2. разницу во времени между регистрацией и первым постом.

WITH p AS
  (SELECT DISTINCT user_id,
                   MIN(creation_date) OVER (PARTITION BY user_id) AS min_dt
   FROM stackoverflow.posts)
SELECT p.user_id,
       (p.min_dt - u.creation_date) AS diff
FROM stackoverflow.users AS u
INNER JOIN p ON u.id = p.user_id;