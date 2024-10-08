-- Find the number of questions that scored more than 300 points 
-- or were added to 'Favorites' at least 100 times.

SELECT COUNT(*)
FROM stackoverflow.posts AS p
LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
WHERE pt.type = 'Question'
  AND (score > 300
       OR favorites_count >= 100);



-- How many questions were asked on average per day from November 1 to 18, 2008 inclusive?
-- Round the result to the nearest whole number.

SELECT ROUND(AVG(num_questions))
FROM
  (SELECT COUNT(p.title) AS num_questions
   FROM stackoverflow.posts AS p
   LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
   WHERE pt.type = 'Question'
     AND CAST(DATE_TRUNC('DAY', p.creation_date) AS date) BETWEEN '2008-11-01' AND '2008-11-18'
   GROUP BY DATE_TRUNC('DAY', p.creation_date)) AS questions_per_day;



-- How many users received badges on the same day they registered? 
-- Display the number of unique users.

SELECT COUNT(DISTINCT(u.id))
FROM stackoverflow.users AS u
LEFT JOIN stackoverflow.badges AS b ON u.id = b.user_id
WHERE CAST(DATE_TRUNC('DAY', u.creation_date) AS date) = CAST(DATE_TRUNC('DAY', b.creation_date) AS date);



-- How many unique posts by the user named Joel Coehoorn received at least one vote?

SELECT COUNT (DISTINCT p.id)
FROM stackoverflow.posts AS p
LEFT JOIN stackoverflow.users AS u ON p.user_id = u.id
LEFT JOIN stackoverflow.votes AS v ON p.id = v.post_id
WHERE display_name = 'Joel Coehoorn'
  AND post_id IS NOT NULL;



-- Extract all fields from the 'vote_types' table. Add a field named 'rank',
-- which contains record numbers in reverse order.
-- The table should be sorted by the 'id' field.

SELECT *,
       ROW_NUMBER() OVER(
                         ORDER BY id DESC) AS rank
FROM stackoverflow.vote_types
ORDER BY id;



-- Select the top 10 users who cast the most 'Close' votes.
-- Display a table with two fields: user ID and vote count.
-- Sort the data first by descending vote count, then by descending user ID.

SELECT u.id,
       COUNT(vt.id) AS COUNT
FROM stackoverflow.users AS u
LEFT JOIN stackoverflow.votes AS v ON u.id = v.user_id
LEFT JOIN stackoverflow.vote_types AS vt ON v.vote_type_id = vt.id
WHERE vt.name = 'Close'
GROUP BY u.id
ORDER BY COUNT DESC
LIMIT 10;



-- Select the top 10 users by the number of badges received from November 15 to December 15, 2008 inclusive.
-- Display the following fields:
-- 1. user ID;
-- 2. number of badges;
-- 3. rank based on the number of badges, with higher badge counts having a higher rank.
-- Assign the same rank to users with the same number of badges.
-- Sort the records by descending badge count, and then by ascending user ID.


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



-- How many points on average does each user get per post?
-- Form a table with the following fields:
-- 1. post title;
-- 2. user ID;
-- 3. post score;
-- 4. average user score per post, rounded to the nearest integer.
-- Exclude posts without titles, as well as those with zero points.

SELECT p.title,
       p.user_id,
       p.score,
       ROUND(AVG(p.score) OVER (PARTITION BY p.user_id))
FROM stackoverflow.posts AS p
WHERE p.title IS NOT NULL
  AND score != 0;



-- Display the titles of posts written by users who received more than 1000 badges.
-- Posts without titles should not be included in the list.

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



-- Write a query to extract data about users from Canada.
-- Divide users into three groups based on the number of profile views:
-- 1. assign group 1 to users with views greater than or equal to 350;
-- 2. assign group 2 to users with views less than 350 but greater than or equal to 100;
-- 3. assign group 3 to users with views less than 100.
-- Display the user ID, profile view count, and group in the final table.
-- Users with views less than or equal to zero should not be included in the final table.

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



-- Extend the previous query. Display the leaders of each group — 
-- users who gained the maximum number of views in their group.
-- Display the fields with the user ID, group, and number of views.
-- Sort the table by descending views, and then by ascending user ID.

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



-- Calculate the daily increase in new users in November 2008.
-- Form a table with the following fields:
-- 1. day number;
-- 2. number of users registered on that day;
-- 3. cumulative number of users.

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



-- For each user who has written at least one post,
-- find the interval between registration and the time of creation of the first post. Display:
-- 1. user ID;
-- 2. the time difference between registration and the first post.

WITH p AS
  (SELECT DISTINCT user_id,
                   MIN(creation_date) OVER (PARTITION BY user_id) AS min_dt
   FROM stackoverflow.posts)
SELECT p.user_id,
       (p.min_dt - u.creation_date) AS diff
FROM stackoverflow.users AS u
INNER JOIN p ON u.id = p.user_id;