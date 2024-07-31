-- Отобразите все записи из таблицы company по компаниям, которые закрылись.

SELECT *
FROM company
WHERE status = 'closed';



-- Отобразите количество привлечённых средств для новостных компаний США. 
-- Используйте данные из таблицы company. 
-- Отсортируйте таблицу по убыванию значений в поле funding_total.

SELECT funding_total
FROM company
WHERE country_code = 'USA'
  AND category_code = 'news'
ORDER BY funding_total DESC;



-- Найдите общую сумму сделок по покупке одних компаний другими в долларах. 
-- Отберите сделки, которые осуществлялись только за наличные с 2011 по 2013 год включительно.

SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
  AND EXTRACT(YEAR
              FROM acquired_at) BETWEEN 2011 AND 2013;



-- Отобразите имя, фамилию и названия аккаунтов людей в поле network_username, 
-- у которых названия аккаунтов начинаются на 'Silver'.

SELECT first_name,
       last_name,
       network_username
FROM people
WHERE network_username LIKE 'Silver%'



-- Выведите на экран всю информацию о людях, у которых названия аккаунтов 
-- в поле network_username содержат подстроку 'money', а фамилия начинается на 'K'.

SELECT *
FROM people
WHERE network_username LIKE '%money%'
  AND last_name LIKE 'K%';



-- Для каждой страны отобразите общую сумму привлечённых инвестиций, 
-- которые получили компании, зарегистрированные в этой стране. 
-- Страну, в которой зарегистрирована компания, можно определить по коду страны. 
-- Отсортируйте данные по убыванию суммы.

SELECT country_code,
       SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;



-- Составьте таблицу, в которую войдёт дата проведения раунда, 
-- а также минимальное и максимальное значения суммы инвестиций, привлечённых в эту дату.
-- Оставьте в итоговой таблице только те записи, 
-- в которых минимальное значение суммы инвестиций не равно нулю и не равно максимальному значению.

SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
AND MIN(raised_amount) != MAX(raised_amount);



-- Создайте поле с категориями:
-- 1. Для фондов, которые инвестируют в 100 и более компаний, назначьте категорию high_activity.
-- 2. Для фондов, которые инвестируют в 20 и более компаний до 100, назначьте категорию middle_activity.
-- 3. Если количество инвестируемых компаний фонда не достигает 20, назначьте категорию low_activity.
-- Отобразите все поля таблицы fund и новое поле с категориями.

SELECT *,
       CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20
                AND invested_companies < 100 THEN 'middle_activity'
           WHEN invested_companies < 20 THEN 'low_activity'
       END AS activity_level
FROM fund;



-- Для каждой из категорий, назначенных в предыдущем задании, 
-- посчитайте округлённое до ближайшего целого числа среднее количество 
-- инвестиционных раундов, в которых фонд принимал участие. 
-- Выведите на экран категории и среднее число инвестиционных раундов. 
-- Отсортируйте таблицу по возрастанию среднего.

SELECT ROUND(AVG(investment_rounds)),
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund
GROUP BY activity
ORDER BY AVG(investment_rounds);



-- Проанализируйте, в каких странах находятся фонды, которые чаще всего инвестируют в стартапы. 
-- Для каждой страны посчитайте минимальное, максимальное и среднее число компаний, 
-- в которые инвестировали фонды этой страны, основанные с 2010 по 2012 год включительно. 
-- Исключите страны с фондами, у которых минимальное число компаний, получивших инвестиции, равно нулю. 
-- Выгрузите десять самых активных стран-инвесторов: отсортируйте таблицу 
-- по среднему количеству компаний от большего к меньшему. 
-- Затем добавьте сортировку по коду страны в лексикографическом порядке.

SELECT country_code,
       MIN(invested_companies),
       MAX(invested_companies),
       AVG(invested_companies)
FROM fund
WHERE EXTRACT(YEAR
              FROM founded_at) BETWEEN 2010 AND 2012
GROUP BY country_code
HAVING MIN(invested_companies) != 0
ORDER BY AVG(invested_companies) DESC, country_code
LIMIT 10;



-- Отобразите имя и фамилию всех сотрудников стартапов. 
-- Добавьте поле с названием учебного заведения, 
-- которое окончил сотрудник, если эта информация известна.

SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT OUTER JOIN education AS e ON p.id = e.person_id;




-- Для каждой компании найдите количество учебных заведений, которые окончили её сотрудники. 
-- Выведите название компании и число уникальных названий учебных заведений.
-- Составьте топ-5 компаний по количеству университетов.

SELECT c.name,
       COUNT(DISTINCT(instituition))
FROM education AS e
INNER JOIN people AS p ON e.person_id = p.id
INNER JOIN company AS c ON p.company_id = c.id
GROUP BY c.name
ORDER BY COUNT DESC
LIMIT 5;



-- Составьте список с уникальными названиями закрытых компаний, 
-- для которых первый раунд финансирования оказался последним.

SELECT DISTINCT(c.name)
FROM company AS c
LEFT OUTER JOIN funding_round AS fr ON c.id = fr.company_id
WHERE status = 'closed'
  AND is_first_round = 1
  AND is_last_round = 1;



-- Составьте список уникальных номеров сотрудников, которые работают в компаниях, 
-- отобранных в предыдущем задании.

SELECT DISTINCT(p.id)
FROM people AS p
LEFT OUTER JOIN company AS c ON p.company_id = c.id
WHERE c.name IN
    (SELECT DISTINCT(c.name)
     FROM company AS c
     LEFT OUTER JOIN funding_round AS fr ON c.id = fr.company_id
     WHERE status = 'closed'
       AND is_first_round = 1
       AND is_last_round = 1);



-- Составьте таблицу, куда войдут уникальные пары с номерами сотрудников 
-- из предыдущей задачи и учебным заведением, которое окончил сотрудник.

SELECT DISTINCT(p.id),
       e.instituition
FROM people AS p
LEFT OUTER JOIN company AS c ON p.company_id = c.id
LEFT OUTER JOIN education AS e ON p.id = e.person_id
WHERE c.name IN
    (SELECT DISTINCT(c.name)
     FROM company AS c
     LEFT OUTER JOIN funding_round AS fr ON c.id = fr.company_id
     WHERE status = 'closed'
       AND is_first_round = 1
       AND is_last_round = 1)
  AND e.instituition IS NOT NULL;



-- Посчитайте количество учебных заведений для каждого сотрудника из предыдущего задания. 
-- При подсчёте учитывайте, что некоторые сотрудники могли окончить одно и то же заведение дважды.

SELECT p.id,
       COUNT(e.instituition)
FROM people AS p
LEFT JOIN education AS e ON p.id = e.person_id
WHERE p.company_id IN
    (SELECT c.id
     FROM company AS c
     JOIN funding_round AS fr ON c.id = fr.company_id
     WHERE STATUS ='closed'
       AND is_first_round = 1
       AND is_last_round = 1
     GROUP BY c.id)
GROUP BY p.id
HAVING COUNT(DISTINCT e.instituition) >0;



-- Дополните предыдущий запрос и выведите среднее число учебных заведений 
-- (всех, не только уникальных), которые окончили сотрудники разных компаний. 
-- Нужно вывести только одну запись, группировка здесь не понадобится.

SELECT AVG(COUNT)
FROM
  (SELECT p.id,
          COUNT(e.instituition)
   FROM people AS p
   LEFT JOIN education AS e ON p.id = e.person_id
   WHERE p.company_id IN
       (SELECT c.id
        FROM company AS c
        JOIN funding_round AS fr ON c.id = fr.company_id
        WHERE STATUS ='closed'
          AND is_first_round = 1
          AND is_last_round = 1
        GROUP BY c.id)
   GROUP BY p.id
   HAVING COUNT(DISTINCT e.instituition) >0) AS abc;



-- Напишите похожий запрос: выведите среднее число учебных заведений 
-- (всех, не только уникальных), которые окончили сотрудники Socialnet.

SELECT AVG(COUNT)
FROM
  (SELECT p.id,
          COUNT(e.instituition)
   FROM people AS p
   LEFT JOIN education AS e ON p.id = e.person_id
   LEFT OUTER JOIN company AS c ON p.company_id = c.id
   WHERE c.name = 'Socialnet'
   GROUP BY p.id
   HAVING COUNT(e.instituition) > 0) AS abc;



-- Составьте таблицу из полей:
-- 1. name_of_fund — название фонда;
-- 2. name_of_company — название компании;
-- 3. amount — сумма инвестиций, которую привлекла компания в раунде.
-- В таблицу войдут данные о компаниях, в истории которых было больше шести важных этапов, 
-- а раунды финансирования проходили с 2012 по 2013 год включительно.

SELECT f.name AS name_of_fund,
       c.name AS name_of_company,
       fr.raised_amount AS amount
FROM investment AS i
LEFT JOIN company AS c ON c.id = i.company_id
LEFT JOIN fund AS f ON i.fund_id = f.id
INNER JOIN
  (SELECT*
   FROM funding_round
   WHERE funded_at BETWEEN '2012-01-01' AND '2013-12-31') AS fr ON fr.id = i.funding_round_id
WHERE c.milestones > 6;



-- Выгрузите таблицу, в которой будут такие поля:
-- 1. название компании-покупателя;
-- 2. сумма сделки;
-- 3. название компании, которую купили;
-- 4. сумма инвестиций, вложенных в купленную компанию;
-- 5. доля, которая отображает, во сколько раз сумма покупки превысила сумму 
-- вложенных в компанию инвестиций, округлённая до ближайшего целого числа.

-- Не учитывайте те сделки, в которых сумма покупки равна нулю. 
-- Если сумма инвестиций в компанию равна нулю, исключите такую компанию из таблицы. 
-- Отсортируйте таблицу по сумме сделки от большей к меньшей, 
-- а затем по названию купленной компании в лексикографическом порядке. 
-- Ограничьте таблицу первыми десятью записями.

WITH acquiring AS
  (SELECT c.name AS buyer,
          a.price_amount AS price,
          a.id AS KEY
   FROM acquisition AS a
   LEFT JOIN company AS c ON a.acquiring_company_id = c.id
   WHERE a.price_amount > 0),
     acquired AS
  (SELECT c.name AS acquisition,
          c.funding_total AS investment,
          a.id AS KEY
   FROM acquisition AS a
   LEFT JOIN company AS c ON a.acquired_company_id = c.id
   WHERE c.funding_total > 0)
SELECT acqn.buyer,
       acqn.price,
       acqd.acquisition,
       acqd.investment,
       ROUND(acqn.price / acqd.investment) AS uplift
FROM acquiring AS acqn
JOIN acquired AS acqd ON acqn.KEY = acqd.KEY
ORDER BY price DESC,
         acquisition
LIMIT 10;



-- Выгрузите таблицу, в которую войдут названия компаний из категории social, 
-- получившие финансирование с 2010 по 2013 год включительно. 
-- Проверьте, что сумма инвестиций не равна нулю. 
-- Выведите также номер месяца, в котором проходил раунд финансирования.

SELECT c.name,
       EXTRACT(MONTH
               FROM funded_at)
FROM company AS c
LEFT JOIN funding_round AS fr ON c.id = fr.company_id
WHERE category_code = 'social'
  AND EXTRACT(YEAR
              FROM fr.funded_at) BETWEEN 2010 AND 2013
  AND fr.raised_amount != 0;



-- Отберите данные по месяцам с 2010 по 2013 год, когда проходили инвестиционные раунды. 
-- Сгруппируйте данные по номеру месяца и получите таблицу, в которой будут поля:
-- 1. номер месяца, в котором проходили раунды;
-- 2. количество уникальных названий фондов из США, которые инвестировали в этом месяце;
-- 3. количество компаний, купленных за этот месяц;
-- 4. общая сумма сделок по покупкам в этом месяце.

SELECT *
FROM
  (SELECT EXTRACT(MONTH
                  FROM fr.funded_at) AS MONTH,
          COUNT(DISTINCT(f.id)) AS USA_funds
   FROM fund AS f
   LEFT JOIN investment AS i ON f.id = i.fund_id
   LEFT JOIN funding_round AS fr ON i.funding_round_id = fr.id
   WHERE EXTRACT(YEAR
                 FROM fr.funded_at) BETWEEN 2010 AND 2013
     AND f.country_code = 'USA'
   GROUP BY MONTH) AS aa
LEFT OUTER JOIN
  (SELECT EXTRACT(MONTH
                  FROM acquired_at) AS MONTH,
          COUNT(acquired_company_id),
          SUM(price_amount)
   FROM acquisition
   WHERE EXTRACT(YEAR
                 FROM acquired_at) BETWEEN 2010 AND 2013
   GROUP BY MONTH) AS bb ON aa.month = bb.month;



-- Составьте сводную таблицу и выведите среднюю сумму инвестиций для стран, 
-- в которых есть стартапы, зарегистрированные в 2011, 2012 и 2013 годах. 
-- Данные за каждый год должны быть в отдельном поле. 
-- Отсортируйте таблицу по среднему значению инвестиций за 2011 год от большего к меньшему.

WITH inv_2011 AS
  (SELECT country_code,
          AVG(funding_total) AS avg2011
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at) = 2011
   GROUP BY country_code),
     inv_2012 AS
  (SELECT country_code,
          AVG(funding_total) AS avg2012
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at) = 2012
   GROUP BY country_code),
     inv_2013 AS
  (SELECT country_code,
          AVG(funding_total) AS avg2013
   FROM company
   WHERE EXTRACT(YEAR
                 FROM founded_at) = 2013
   GROUP BY country_code)
SELECT inv_2011.country_code,
       avg2011,
       avg2012,
       avg2013
FROM inv_2011
INNER JOIN inv_2012 ON inv_2011.country_code = inv_2012.country_code
INNER JOIN inv_2013 ON inv_2012.country_code = inv_2013.country_code
ORDER BY avg2011 DESC