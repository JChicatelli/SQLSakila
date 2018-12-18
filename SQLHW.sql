USE sakila;
 

SELECT first_name, last_name
FROM actor;

SELECT CONCAT (first_name,'  ',last_name) as 'Actor Name'
FROM actor;

SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%GEN%";

SELECT last_name,  first_name
FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name;

SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

DESCRIBE actor;

ALTER TABLE actor
ADD middle_name varchar(45) NOT NULL AFTER first_name;

SELECT * FROM actor;

ALTER TABLE actor
MODIFY middle_name BLOB NOT NULL;

DESCRIBE actor;

ALTER TABLE actor
DROP  middle_name;

DESCRIBE actor;


SELECT last_name, COUNT(*) AS 'Number of actors with last name'
FROM actor
GROUP BY last_name;


SELECT last_name, COUNT(*) AS COUNT
FROM actor
GROUP BY last_name
HAVING COUNT >= 2;


UPDATE actor SET first_name = REPLACE(first_name, 'GROUCHO','HARPO');


SELECT * FROM actor
WHERE first_name = "GROUCHO";

SELECT * FROM actor
WHERE first_name = "HARPO";


UPDATE actor SET first_name = REPLACE(first_name,'HARPO', 'GROUCHO');

SELECT * FROM actor
WHERE first_name = "GROUCHO";

SELECT * FROM actor
WHERE  last_name = "WILLIAMS";



SHOW CREATE TABLE address;



SELECT s.first_name, s.last_name, a.address 
FROM staff AS s
LEFT JOIN address AS a
ON (s.address_id = a.address_id);


SELECT CONCAT("$",FORMAT(SUM(amount),2)) AS Total FROM payment
WHERE payment_date LIKE '2005-08%';


SELECT s.first_name, s.last_name, p.staff_id, CONCAT("$",FORMAT(SUM(amount),2)) AS Total
FROM staff AS s
JOIN payment AS p
ON (s.staff_id = p.staff_id) AND p.payment_date LIKE '2005-08%'
GROUP BY p.staff_id;


SELECT f.title, COUNT(fa.actor_id) AS 'Number of Actors'
FROM film AS f
INNER JOIN film_actor AS fa
ON (f.film_id = fa.film_id)
GROUP BY f.film_id;


SELECT f.title, (
SELECT COUNT(*) FROM inventory AS i
WHERE f.film_id = i.film_id
) AS 'Number of Copies'
FROM film AS f
WHERE f.title = "Hunchback Impossible";


SELECT customer_id, SUM(amount) AS 'Total Paid'
FROM payment
GROUP BY customer_id;


SELECT last_name, first_name, customer_id
FROM customer
ORDER BY last_name ASC;



SELECT  c.first_name, c.last_name, CONCAT("$",FORMAT(SUM(p.amount),2)) AS 'Total Amount Paid'
FROM payment AS p
JOIN customer AS c
ON (p.customer_id =  c.customer_id)
GROUP BY p.customer_id
ORDER BY c.last_name ASC;



SELECT f.title
FROM film AS f
WHERE f.language_id IN (
	SELECT l.language_id
	FROM language AS l
WHERE f.title LIKE 'K%' OR f.title LIKE 'Q%' AND l.name = "English"
);

SELECT title, language_id 
FROM film 
WHERE title LIKE 'K%' OR title LIKE 'Q%' ;

SELECT first_name, last_name
 FROM actor
 WHERE actor_id IN (
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN (
		SELECT film_id 
		FROM film
		WHERE title = "Alone Trip")
		);

SELECT  c.first_name, c.last_name, c.email, country.country
FROM address AS a
JOIN city
ON (city.city_id =  a.city_id)
JOIN customer AS c
ON (c.address_id = a.address_id)
JOIN country
ON (country.country_id = city.country_id)
WHERE country.country = 'Canada';


SELECT f.title, c.name AS 'Type of Film'
FROM category AS c
JOIN film_category AS fc
ON (fc.category_id = c.category_id)
JOIN film AS f
ON(f.film_id = fc.film_id)
WHERE c.name = "Family";


SELECT f.title, COUNT(f.title) AS 'Number_Rented'
FROM film AS f
JOIN inventory AS i 
ON(i.film_id = f.film_id)
JOIN rental AS r
ON (i.inventory_id = r.inventory_id)
GROUP BY f.title
ORDER BY COUNT(f.title) DESC;


SELECT s.store_id, CONCAT("$",FORMAT(SUM(p.amount),2)) AS 'Money Made'
FROM store AS s
JOIN inventory AS i
ON(i.store_id = s.store_id)
JOIN rental AS r
ON (r.inventory_id = i.inventory_id)
JOIN payment AS p
ON(p.rental_id = r.rental_id)
GROUP BY s.store_id;


SELECT s.store_id, city.city, country 
FROM store AS s
LEFT JOIN address AS a
ON(a.address_id = s.address_id)
INNER JOIN city
ON (city.city_id = a.city_id)
INNER JOIN country AS c
ON(c.country_id = city.country_id)
GROUP BY s.store_id;


SELECT cat.name AS 'Film Genre', CONCAT("$",FORMAT(SUM(p.amount),2)) AS 'Gross Revenue'
FROM category AS cat
JOIN film_category AS fc
ON(fc.category_id = cat.category_id)
JOIN inventory AS i
ON (i.film_id = fc.film_id)
JOIN rental AS r
ON(r.inventory_id = i.inventory_id)
JOIN payment AS p
ON(p.rental_id = r.rental_id)
GROUP BY cat.name
ORDER BY SUM(p.amount) DESC
LIMIT 5;


CREATE VIEW top_five_genres AS
SELECT cat.name AS 'Film Genre', CONCAT("$",FORMAT(SUM(p.amount),2)) AS 'Gross Revenue'
	FROM category AS cat
    JOIN film_category AS fc
    ON(fc.category_id = cat.category_id)
    JOIN inventory AS i
	ON (i.film_id = fc.film_id)
	JOIN rental AS r
	ON(r.inventory_id = i.inventory_id)
	JOIN payment AS p
	ON(p.rental_id = r.rental_id)
	GROUP BY cat.name
	ORDER BY SUM(p.amount) DESC
    LIMIT 5;

SELECT * FROM top_five_genres;
 

DROP VIEW top_five_genres;