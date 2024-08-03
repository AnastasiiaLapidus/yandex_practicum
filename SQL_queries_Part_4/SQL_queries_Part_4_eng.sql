-- Count how many books were published after January 1, 2000.

SELECT COUNT(book_id)
FROM books
WHERE publication_date > '2000-01-01';



-- For each book, count the number of reviews and calculate the average rating.

SELECT b.book_id,
       b.title,
       COUNT(DISTINCT rv.review_id) AS reviews_count,
       AVG(rt.rating) AS avg_rating
FROM books AS b
LEFT JOIN ratings AS rt ON b.book_id = rt.book_id
LEFT JOIN reviews AS rv ON b.book_id = rv.book_id
GROUP BY b.book_id;



-- Determine the publisher that released the highest number of books with more than 50 pages — 
-- this way the brochures will be excluded.

SELECT b.publisher_id,
       p.publisher,
       COUNT(b.book_id) AS number_of_books
FROM books AS b
LEFT JOIN publishers AS p ON b.publisher_id = p.publisher_id
WHERE b.num_pages > 50
GROUP BY b.publisher_id,
         p.publisher
ORDER BY COUNT(b.book_id) DESC
LIMIT 1;



-- Identify the author with the highest average book rating — 
-- consider only books with 50 or more ratings.

SELECT a.author_id,
       a.author,
       AVG(rt.rating) AS avg_rating
FROM books AS b
LEFT JOIN authors AS a ON b.author_id = a.author_id
LEFT JOIN ratings AS rt ON b.book_id = rt.book_id
WHERE b.book_id IN
    (SELECT b.book_id
     FROM books AS b
     LEFT JOIN ratings AS rt ON b.book_id = rt.book_id
     GROUP BY b.book_id,
              b.title
     HAVING COUNT(rt.rating) >= 50)
GROUP BY a.author_id,
         a.author
ORDER BY AVG(rt.rating) DESC
LIMIT 1;



-- Calculate the average number of reviews from users who have given more than 48 ratings.

SELECT AVG(review_count)
FROM
  (SELECT rv.username,
          COUNT(DISTINCT rv.review_id) AS review_count
   FROM reviews AS rv
   JOIN ratings AS rt ON rv.book_id = rt.book_id
   WHERE rv.username IN
       (SELECT username
        FROM ratings
        GROUP BY username
        HAVING COUNT(rating) > 48)
   GROUP BY rv.username) AS i;