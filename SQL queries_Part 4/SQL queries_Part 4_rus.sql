-- Посчитайте сколько книг вышло после 1 января 2000 года.

SELECT COUNT(book_id)
FROM books
WHERE publication_date > '2000-01-01';



-- Для каждой книги посчитайте количество обзоров и среднюю оценку.

SELECT b.book_id,
       b.title,
       COUNT(DISTINCT rv.review_id) AS reviews_count,
       AVG(rt.rating) AS avg_rating
FROM books AS b
LEFT JOIN ratings AS rt ON b.book_id = rt.book_id
LEFT JOIN reviews AS rv ON b.book_id = rv.book_id
GROUP BY b.book_id;



-- Определите издательство, которое выпустило наибольшее число книг толще 50 страниц — 
-- так вы исключите из анализа брошюры.

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



-- Определите автора с самой высокой средней оценкой книг — 
-- учитывайте только книги с 50 и более оценками.

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



-- Посчитайте среднее количество обзоров от пользователей, которые поставили
-- больше 48 оценок.

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