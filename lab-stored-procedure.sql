# Lab | Stored procedures
# In this lab, we will continue working on the Sakila database of movie rentals.

# Instructions
# Write queries, stored procedures to answer the following questions:

# In the previous lab we wrote a query to find first name, last name, and emails of all the customers who rented Action movies. Convert the query into a simple stored procedure. Use the following query:
  SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = 'Action'
GROUP BY first_name , last_name , email;

# As a stored procedure
DELIMITER //
CREATE PROCEDURE name_list_no_var ()
BEGIN
   SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = 'Action'
GROUP BY first_name , last_name , email;  
END;
//
delimiter ;

CALL name_list_no_var;

DROP PROCEDURE name_list_no_var;

# Now keep working on the previous stored procedure to make it more dynamic. 
# Update the stored procedure in a such manner that it can take a string argument for the category name and return the results for all customers that rented movie of that category/genre. 
# For eg., it could be action, animation, children, classics, etc.
DELIMITER //
CREATE PROCEDURE name_list (IN param1 VARCHAR(30))
BEGIN
   SELECT 
    first_name, last_name, email
FROM
    customer
        JOIN
    rental ON customer.customer_id = rental.customer_id
        JOIN
    inventory ON rental.inventory_id = inventory.inventory_id
        JOIN
    film ON film.film_id = inventory.film_id
        JOIN
    film_category ON film_category.film_id = film.film_id
        JOIN
    category ON category.category_id = film_category.category_id
WHERE
    category.name = param1 COLLATE utf8mb4_general_ci
GROUP BY first_name , last_name , email;  
END;
//
DELIMITER ;

CALL name_list("Sci-Fi");

DROP PROCEDURE name_list;

# Write a query to check the number of movies released in each movie category. 
SELECT 
    fc.category_id, c.name, COUNT(*) AS number_of_films
FROM
    film_category fc
JOIN
	category c ON c.category_id = fc.category_id
GROUP BY
	category_id, c.name
ORDER BY
	c.name ASC;
    
# Convert the query in to a stored procedure to filter only those categories that have movies released greater than a certain number.
DELIMITER //
CREATE PROCEDURE cat_count_no_var ()
BEGIN
	SELECT 
		fc.category_id, c.name, COUNT(*) AS number_of_films
	FROM
		film_category fc
	JOIN
		category c ON c.category_id = fc.category_id
	GROUP BY
		category_id, c.name
	HAVING
		number_of_films > 60
	ORDER BY
		number_of_films ASC;
END;
//
DELIMITER ;

CALL cat_count_no_var;
   
# Pass that number as an argument in the stored procedure.
DELIMITER //
CREATE PROCEDURE cat_count (IN param1 INT)
BEGIN
	SELECT 
		fc.category_id, c.name, COUNT(*) AS number_of_films
	FROM
		film_category fc
	JOIN
		category c ON c.category_id = fc.category_id
	GROUP BY
		category_id, c.name
	HAVING
		number_of_films > param1
	ORDER BY
		number_of_films ASC;
END;
//
DELIMITER ;

CALL cat_count(61);

