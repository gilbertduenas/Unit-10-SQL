USE sakila;

/*
1a. Display the first and last names of all actors from the table actor.
*/
SELECT actor.first_name, actor.last_name
FROM actor;

/*
1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
*/
SELECT upper(concat(first_name, ' ', actor.last_name)) 
AS 'Actor Name'
FROM actor;

/*
2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
*/
SELECT actor.actor_id, actor.first_name, actor.last_name
FROM actor
WHERE actor.first_name LIKE '%joe%';

/*
2b. Find all actors whose last name contain the letters GEN:
*/
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.last_name LIKE '%gen%';

/*
2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
*/
SELECT actor.last_name, actor.first_name
FROM actor
WHERE actor.last_name LIKE '%li%'
ORDER BY actor.last_name;

/*
2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
*/
SELECT country.country_id, country.country
FROM country
WHERE country.country IN ('Afghanistan', 'Bangladesh', 'China');

/*
3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
*/
ALTER TABLE actor
ADD description BLOB;

/*
3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column.
*/
ALTER TABLE actor
DROP COLUMN description;

/*
4a. List the last names of actors, as well as how many actors have that last name.
*/
SELECT actor.last_name, COUNT(actor.last_name)  AS 'Count'
FROM actor
GROUP BY actor.last_name;

/*
4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
*/
SELECT actor.last_name, COUNT(*) AS 'Count'
FROM actor
GROUP BY actor.last_name
HAVING COUNT(*) > 1;

/*
4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
*/
UPDATE actor
SET actor.first_name = 'HARPO'
WHERE actor.first_name = 'groucho' AND actor.last_name = 'williams';

/*
4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
*/
UPDATE actor
SET actor.first_name = 'GROUCHO'
WHERE actor.first_name = 'harpo' AND actor.last_name = 'williams';

/*
5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
*/
SHOW CREATE TABLE address;

/*
6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
*/
SELECT staff.first_name, staff.last_name, address.address
FROM address
JOIN staff ON address.address_id = staff.address_id;

/*
6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
*/
SELECT staff.first_name, staff.last_name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS 'Sales'
FROM staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY staff.staff_id;

/*
6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
*/
SELECT film.title, COUNT(film_actor.actor_id) AS 'Count'
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
GROUP BY film.title;

/*
6d. How many copies of the film Hunchback Impossible exist in the inventory system?
*/
SELECT film.title, COUNT(inventory.inventory_id) AS 'Count'
FROM film
INNER JOIN inventory ON film.film_id = inventory.film_id
WHERE film.title = 'hunchback impossible';

/*
6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
*/
SELECT customer.last_name, customer.first_name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS 'Paid'
FROM customer
JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id
ORDER BY customer.last_name;

/*
7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
*/
SELECT film.title
FROM film
WHERE film.title LIKE 'k%' OR film.title LIKE 'q%'
AND film.language_id IN (
	SELECT language.language_id
	FROM language
	WHERE language.name = 'english');

/*
7b. Use subqueries to display all actors who appear in the film Alone Trip.
*/
SELECT actor.first_name, actor.last_name
FROM actor
WHERE actor.actor_id IN (
	SELECT film_actor.actor_id
	FROM film_actor
	WHERE film_actor.film_id IN (
		SELECT film.film_id
		FROM film
		WHERE film.title = 'alone trip'));

/*
7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
*/
SELECT customer.first_name, customer.last_name, customer.email, country.country
FROM customer
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id
WHERE country.country = 'canada';

/*
7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
*/
SELECT film.title, film.rating 
FROM film
WHERE rating = 'g';

SELECT film.title, film.rating 
FROM film
WHERE rating = 'pg';

/*
7e. Display the most frequently rented movies in descending order.
*/
SELECT film.title, film.film_id, inventory.inventory_id, rental.rental_id, count(*) AS 'Count'
FROM film
	JOIN inventory ON film.film_id = inventory.film_id
	JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY film.title
ORDER BY id_count DESC;

/*
7f. Write a query to display how much business, in dollars, each store brought in.
*/
SELECT store.store_id, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS 'Sales'
FROM store
	JOIN staff ON store.store_id = staff.store_id
	JOIN rental ON staff.staff_id = rental.staff_id
	JOIN payment ON rental.rental_id = payment.payment_id
GROUP BY store.store_id;

/*
7g. Write a query to display for each store its store ID, city, and country.
*/
SELECT store.store_id, city.city, country.country
FROM store
	JOIN address ON store.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON city.country_id = country.country_id;

/*
7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
*/
SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS 'Sales'
FROM category
	JOIN film_category ON film_category.category_id = category.category_id
	JOIN film ON film.film_id = film_category.film_id
	JOIN inventory ON inventory.inventory_id = film.film_id
	JOIN rental ON rental.inventory_id = inventory.inventory_id
	JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

/*
8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
*/
CREATE VIEW executive_view AS
SELECT category.name, CONCAT('$', FORMAT(SUM(payment.amount), 2)) AS 'Sales'
FROM category
	JOIN film_category ON film_category.category_id = category.category_id
	JOIN film ON film.film_id = film_category.film_id
	JOIN inventory ON inventory.inventory_id = film.film_id
	JOIN rental ON rental.inventory_id = inventory.inventory_id
	JOIN payment ON payment.rental_id = rental.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

/*
8b. How would you display the view that you created in 8a?
*/
SELECT * FROM executive_view;

/*
8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
*/
DROP VIEW executive_view;
