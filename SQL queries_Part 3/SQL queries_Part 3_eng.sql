-- Display the total number of views for posts published in each month of 2008. 
-- If there is no data for a particular month, that month can be skipped. 
-- Sort the result in descending order by the total number of views.

SELECT month_truncated_date,
       SUM(views_count) AS total_views
FROM
  (SELECT CAST(DATE_TRUNC('MONTH', creation_date) AS date) AS month_truncated_date,
          views_count
   FROM stackoverflow.posts
   WHERE EXTRACT(YEAR
                 FROM creation_date) = 2008) AS subquery
GROUP BY month_truncated_date
ORDER BY total_views DESC;



-- Display the names of the most active users who gave more than 100 answers 
-- in the first month after registration (including the day of registration). 
-- Do not consider the questions asked by users. 
-- For each user name, display the number of unique 'user_ids'. 
-- Sort the result lexicographically by user names.

SELECT user_name,
       unique_user_ids
FROM
  (SELECT user_name,
          COUNT(DISTINCT user_id) AS unique_user_ids,
          COUNT(post_id) AS post_count
   FROM
     (SELECT u.id AS user_id,
             u.display_name AS user_name,
             u.creation_date AS user_creation_date,
             p.id AS post_id,
             p.creation_date AS post_creation_date
      FROM stackoverflow.users AS u
      LEFT JOIN stackoverflow.posts AS p ON u.id = p.user_id
      LEFT JOIN stackoverflow.post_types AS pt ON p.post_type_id = pt.id
      WHERE pt.type = 'Answer'
        AND p.creation_date::date <= (u.creation_date::date + INTERVAL '1 month')) AS i
   GROUP BY user_name
   HAVING COUNT(post_id) > 100
   ORDER BY user_name) AS j;



-- Display the number of posts by month for the year 2008. 
-- Select posts from users who registered in September 2008 
-- and made at least one post in December of the same year.
-- Sort the table by the month value in descending order.

SELECT CAST(DATE_TRUNC('MONTH', creation_date) AS date) AS the_month,
       COUNT(id) AS COUNT
FROM stackoverflow.posts
WHERE EXTRACT(YEAR
              FROM creation_date) = 2008
  AND user_id IN
    (SELECT user_id
     FROM
       (SELECT u.id AS user_id,
               u.creation_date AS user_creation_date,
               p.id AS post_id,
               p.creation_date AS post_creation_date
        FROM stackoverflow.users AS u
        LEFT JOIN stackoverflow.posts AS p ON u.id = p.user_id
        WHERE EXTRACT(YEAR
                      FROM u.creation_date) = 2008
          AND EXTRACT(MONTH
                      FROM u.creation_date) = 9
          AND CAST(DATE_TRUNC('MONTH', p.creation_date) AS date) = '2008-12-01') AS i)
GROUP BY CAST(DATE_TRUNC('MONTH', creation_date) AS date)
ORDER BY the_month DESC;



-- Using post data, display the following fields:
-- 1. User ID who wrote the post;
-- 2. Post creation date;
-- 3. Number of views of the current post;
-- 4. Cumulative number of views for the author's posts.
-- The data in the table should be sorted by ascending user IDs and, 
-- for the same user, by ascending post creation dates.

SELECT user_id,
       creation_date,
       views_count,
       SUM(views_count) OVER(PARTITION BY user_id
                             ORDER BY creation_date)
FROM stackoverflow.posts
ORDER BY user_id,
         creation_date;



-- How many days on average did users interact with the platform 
-- in the period from December 1 to 7, 2008, inclusive? 
-- For each user, select the days on which they published at least one post. 
-- You need to get one whole number — do not forget to round the result.

SELECT ROUND(AVG(COUNT))
FROM
  (SELECT user_id,
          COUNT(the_date)
   FROM
     (SELECT DISTINCT user_id,
                      CAST(DATE_TRUNC('DAY', creation_date) AS date) AS the_date
      FROM stackoverflow.posts
      WHERE CAST(DATE_TRUNC('DAY', creation_date) AS date) BETWEEN '2008-12-01' AND '2008-12-07'
      ORDER BY user_id) AS i
   GROUP BY user_id) AS j;



-- By what percentage did the number of posts change monthly from September 1 to December 31, 2008? 
-- Display the table with the following fields:
-- 1. Month number.
-- 2. Number of posts per month.
-- 3. Percentage change in the number of posts in the current month compared to the previous month.
-- If the number of posts decreased, the percentage value should be negative; if increased, positive. 
-- Round the percentage value to two decimal places.
-- Note that when dividing one integer by another in PostgreSQL, 
-- the result will be an integer rounded down to the nearest whole number. 
-- To avoid this, convert the dividend to type 'numeric'.

SELECT MONTH,
       post_count,
       ROUND((post_count::numeric - prev_month_post_count::numeric)/prev_month_post_count::numeric*100, 2)
FROM
  (SELECT EXTRACT(MONTH
                  FROM creation_date) AS MONTH,
          COUNT(id) AS post_count,
          LAG(COUNT(id)) OVER (
                               ORDER BY EXTRACT(MONTH
                                                FROM creation_date)) AS prev_month_post_count
   FROM stackoverflow.posts
   WHERE CAST(DATE_TRUNC('DAY', creation_date) AS date) BETWEEN '2008-09-01' AND '2008-12-31'
   GROUP BY EXTRACT(MONTH
                    FROM creation_date)
   ORDER BY EXTRACT(MONTH
                    FROM creation_date)) AS i;



-- Find the user who published the most posts since registration. 
-- Display their activity data for October 2008 as follows:
-- 1. Week number;
-- 2. Date and time of the last post published that week.

SELECT DISTINCT EXTRACT(WEEK
                        FROM i.creation_date) AS week_number,
                MAX(i.creation_date) OVER(PARTITION BY EXTRACT(WEEK
                                                               FROM i.creation_date)) AS max_creation_date
FROM
  (SELECT *
   FROM stackoverflow.posts
   WHERE CAST(DATE_TRUNC('DAY', creation_date) AS date) BETWEEN '2008-10-01' AND '2008-10-31'
     AND user_id IN
       (SELECT user_id
        FROM stackoverflow.posts
        GROUP BY user_id
        ORDER BY COUNT(id) DESC
        LIMIT 1)) AS i
GROUP BY week_number,
         i.creation_date;