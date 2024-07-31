-- Display all records from the 'company' table for companies that have closed.

SELECT *
FROM company
WHERE status = 'closed';



-- Display the amount of funds raised for US news companies. 
-- Use data from the 'company' table. 
-- Sort the table in descending order by the 'funding_total' field.

SELECT funding_total
FROM company
WHERE country_code = 'USA'
  AND category_code = 'news'
ORDER BY funding_total DESC;



-- Find the total amount of acquisition deals in dollars where companies
-- were purchased by other companies for cash from 2011 to 2013 inclusive.

SELECT SUM(price_amount)
FROM acquisition
WHERE term_code = 'cash'
  AND EXTRACT(YEAR
              FROM acquired_at) BETWEEN 2011 AND 2013;



-- Display the first name, last name, and usernames from the 'network_username' field of people 
-- whose account names start with 'Silver'.

SELECT first_name,
       last_name,
       network_username
FROM people
WHERE network_username LIKE 'Silver%'



-- Display all information about people whose usernames in the 'network_username' field 
-- contain the substring 'money' and whose last name starts with 'K'.

SELECT *
FROM people
WHERE network_username LIKE '%money%'
  AND last_name LIKE 'K%';



-- For each country, display the total amount of funds raised by companies registered in that country. 
-- The coutry, which the company is registered in, may be defined by the country code. 
-- Sort the data in descending order by the total amount.

SELECT country_code,
       SUM(funding_total)
FROM company
GROUP BY country_code
ORDER BY SUM(funding_total) DESC;



-- Create a table that includes the date of the funding round 
-- and the minimum and maximum amounts of investments raised on that date. 
-- Only include records where the minimum investment amount is not zero and not equal to the maximum amount.

SELECT funded_at,
       MIN(raised_amount),
       MAX(raised_amount)
FROM funding_round
GROUP BY funded_at
HAVING MIN(raised_amount) != 0
AND MIN(raised_amount) != MAX(raised_amount);



-- Create a category field:
-- 1. Assign the category 'high_activity' to funds that invest in 100 or more companies.
-- 2. Assign the category 'middle_activity' to funds that invest in 20 to 100 companies.
-- 3. Assign the category 'low_activity' to funds that invest in fewer than 20 companies.
-- Display all fields from the 'fund' table and the new category field.

SELECT *,
       CASE
           WHEN invested_companies >= 100 THEN 'high_activity'
           WHEN invested_companies >= 20
                AND invested_companies < 100 THEN 'middle_activity'
           WHEN invested_companies < 20 THEN 'low_activity'
       END AS activity_level
FROM fund;



-- For each category assigned in the previous task, calculate the rounded average number of investment rounds 
-- in which the fund participated. Display the categories and the average number of investment rounds. 
-- Sort the table in ascending order by the average.

SELECT ROUND(AVG(investment_rounds)),
       CASE
           WHEN invested_companies>=100 THEN 'high_activity'
           WHEN invested_companies>=20 THEN 'middle_activity'
           ELSE 'low_activity'
       END AS activity
FROM fund
GROUP BY activity
ORDER BY AVG(investment_rounds);



-- Analyze which countries have funds that most frequently invest in startups. 
-- For each country, calculate the minimum, maximum, and average number of companies 
-- in which funds from that country have invested, founded between 2010 and 2012 inclusive. 
-- Exclude countries with funds where the minimum number of companies which got investments is zero. 
-- Extract the top ten most active investor countries: 
-- sort the table by the average number of companies from highest to lowest. 
-- Then sort by country code in lexicographical order.

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



-- Display the first and last names of all startup employees. 
-- Add a field with the name of the educational institution 
-- attended by the employee if this information is known.

SELECT p.first_name,
       p.last_name,
       e.instituition
FROM people AS p
LEFT OUTER JOIN education AS e ON p.id = e.person_id;




-- For each company, find the number of educational institutions attended by its employees. 
-- Display the company name and the number of unique educational institutions. 
-- Create a top-5 list of companies by the number of universities.

SELECT c.name,
       COUNT(DISTINCT(instituition))
FROM education AS e
INNER JOIN people AS p ON e.person_id = p.id
INNER JOIN company AS c ON p.company_id = c.id
GROUP BY c.name
ORDER BY COUNT DESC
LIMIT 5;



-- Create a list of unique names of closed companies 
-- for which the first funding round was also the last.

SELECT DISTINCT(c.name)
FROM company AS c
LEFT OUTER JOIN funding_round AS fr ON c.id = fr.company_id
WHERE status = 'closed'
  AND is_first_round = 1
  AND is_last_round = 1;



-- Create a list of unique employee IDs for those 
-- working in companies selected in the previous task.

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



-- Create a table with unique pairs of employee IDs from the previous task 
-- and the educational institution attended by the employee.

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



-- Count the number of educational institutions for each employee from the previous task. 
-- Consider that some employees might have graduated from the same institution twice.

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



-- Extend the previous query to display the average number of educational institutions 
-- (all, not just unique) attended by employees from different companies. 
-- Only one record is needed, no grouping is required.

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



-- Write a similar query: display the average number of educational institutions 
-- (all, not just unique) attended by employees of Socialnet.

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



-- Create a table with the following fields:
-- 1. `name_of_fund` — the name of the fund;
-- 2. `name_of_company` — the name of the company;
-- 3. `amount` — the amount of investment raised by the company in the round.
-- The table should include data on companies that had more than six significant milestones 
-- in their history and whose funding rounds took place from 2012 to 2013 inclusive.

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



-- Extract a table with the following fields:
-- 1. buyer company name;
-- 2. deal amount;
-- 3. name of the company acquired;
-- 4. investment amount in the acquired company;
-- 5. ratio showing how many times the deal amount exceeded the investment amount in the company, 
-- rounded to the nearest integer.

-- Ignore deals where the purchase amount is zero.
-- If the investment amount in the company is zero, exclude that company from the table.
-- Sort the table by deal amount in descending order, 
-- then by the name of the acquired company in lexicographical order.
-- Limit the table to the first ten records.

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



-- Extract a table that includes the names of companies in the 'social' category 
-- that received funding from 2010 to 2013 inclusive.
-- Ensure that the investment amount is not zero.
-- Also display the month number in which the funding round took place.

SELECT c.name,
       EXTRACT(MONTH
               FROM funded_at)
FROM company AS c
LEFT JOIN funding_round AS fr ON c.id = fr.company_id
WHERE category_code = 'social'
  AND EXTRACT(YEAR
              FROM fr.funded_at) BETWEEN 2010 AND 2013
  AND fr.raised_amount != 0;



-- Select data by months from 2010 to 2013 when investment rounds took place.
-- Group the data by month number and get a table with the following fields:
-- 1. month number when the rounds took place;
-- 2. number of unique US-based funds that invested in that month;
-- 3. number of companies acquired that month;
-- 4. total amount of acquisition deals that month.

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



-- Create a pivot table and display the average investment amount 
-- for countries with startups registered in 2011, 2012, and 2013.
-- Data for each year should be in a separate field.
-- Sort the table by the average investment value for 2011 in descending order.

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