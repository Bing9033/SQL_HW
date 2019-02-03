USE sakila;
#1a. Display the first and last names 
SELECT first_name,last_name
FROM actor;
#1b. Combine first and last name. Name the column Actor Name.
SELECT concat(first_name,' ',last_name) as Actor_Name
FROM actor;
#2a.find the ID number, first name, last name, of whom first name, "Joe"
SELECT actor_id,first_name,last_name
FROM actor
WHERE first_name="Joe";
#2b. Find all actors whose last name contain the letters GEN:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE'%GEN%';

#2c. Find all actors whose last names contain the letters LI&order by last name and first name
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE'%LI%'
ORDER BY last_name, first_name ASC;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, China:
SELECT country_id, country
FROM country
WHERE country in('Afghanistan', 'Bangladesh', 'China');

#3a. Creat new column "Discription" and use the data type BLOB
ALTER TABLE actor
ADD COLUMN Discription BLOB;

#3b. Delete the description column
ALTER TABLE actor
DROP COLUMN Discription;

#4a. List the last names of actors, as well as how many actors have that last name
SELECT last_name, count(last_name) AS 'Counts' FROM actor
group by last_name;

#4b. List last names of actors and the number of actors (only for names that are shared by at least two actors)
SELECT last_name, count(last_name) AS 'Counts' FROM actor
group by last_name
HAVING counts>=2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS
UPDATE actor
SET first_name='HARPO'
WHERE last_name='WILLIAMS' and first_name='GROUCHO';

#4d. the first name of the actor is currently HARPO, change it to GROUCHO
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name='GROUCHO'
WHERE first_name='HARPO';
SELECT * FROM actor
WHERE first_name='GROUCHO';
#4d-Alternative 
#check the id that first_
select * from actor
where first_name='HARPO' and last_name='WILLIAMS';
update actor
set first_name='Groucho'
where actor_id=172;

#5a. recreate Address table
show create table address;
describe address;

#5b. 6a. Use JOIN to display the first,last names,address, of each staff member. 
#Use the tables staff and address
SELECT first_name, last_name,address 
FROM staff s
JOIN address a
ON (s.address_id = a.address_id);

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005
#Use tables staff and payment.
SELECT s.first_name,s.last_name,sum(amount) AS 'Total amount'
FROM payment p
JOIN staff s
ON (p.staff_id = s.staff_id)
WHERE payment_date like '%2005-08%'
group by p.staff_id;

#6c. List each film and the number of actors who are listed for that film. 
#Use tables film_actor and film. Use inner join.
SELECT f.title, count(a.actor_id) as'Number of actor' 
FROM film AS f
INNER JOIN film_actor AS a ON f.film_id = a.film_id
group by a.film_id;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
select f.title, count(i.film_id) as 'Number of Copies'
from film AS f
join inventory AS i
on f.film_id = i.film_id
where title = 'Hunchback Impossible';

#6e. Using the tables payment and customer and the JOIN command, 
#list the total paid by each customer. List the customers alphabetically by last name
select c.first_name,c.last_name,sum(p.amount)as 'Total Amount Paid'
from customer AS c
join payment AS p
on c.customer_id = p.customer_id
group by c.customer_id
order by c.last_name ASC;

#Use subqueries to display titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE language_id IN (
					SELECT language_id
                    FROM language
					WHERE name='English')
AND (title LIKE 'K%') or (title LIKE 'Q%');

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
		(SELECT actor_id
         FROM film_actor
         WHERE film_id IN
						(SELECT film_id
                         FROM film
                         WHERE title = 'Alone Trip')
                         );
                         
#7c. You want to run an email marketing campaign in Canada,
# for which you will need the names and email addresses of all Canadian customers. 
SELECT c.first_name, c.last_name,c.email
from customer AS c
join address AS a
on c.address_id=a.address_id
join city
on a.city_id=city.city_id
join country
on city.country_id=country.country_id
where country.country='Canada';

#7d. Identify all movies categorized as family films
SELECT title
FROM film AS f
JOIN film_category AS fc
ON f.film_id=fc.film_id
JOIN category AS cg
ON fc.category_id=cg.category_id
WHERE cg.name='Family';

#7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(r.rental_id) AS 'Number_rentals'
FROM rental AS r
JOIN inventory AS i
ON r.inventory_id=i.inventory_id
JOIN film AS f
ON i.film_id=f.film_id
GROUP BY f.title
ORDER BY Number_rentals DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT store.store_id, SUM(payment.amount) as 'Revenue'
FROM store
JOIN staff
ON store.store_id=staff.store_id
JOIN payment
ON staff.staff_id=payment.staff_id
GROUP BY store.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country
FROM store
JOIN address
ON store.address_id=address.address_id
JOIN city
ON address.city_id=city.city_id
JOIN country
ON city.country_id=country.country_id;

#7h. List the top five genres in gross revenue in descending order. 
SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category
ON category.category_id=film_category.category_id
JOIN inventory
ON film_category.film_id=inventory.film_id
JOIN rental
ON inventory.inventory_id=rental.inventory_id
JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8a. create a view for the Top five genres by gross revenue
CREATE VIEW top_five_genres AS

SELECT category.name, SUM(payment.amount) AS 'Gross Revenue'
FROM category
JOIN film_category
ON category.category_id=film_category.category_id
JOIN inventory
ON film_category.film_id=inventory.film_id
JOIN rental
ON inventory.inventory_id=rental.inventory_id
JOIN payment
ON rental.rental_id=payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

#8b. display the view
SELECT * FROM top_five_genres;

#8c. delect the view
DROP VIEW top_five_genres;