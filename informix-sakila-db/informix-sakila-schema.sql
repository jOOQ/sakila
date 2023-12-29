/*

Sakila for Informix is a port of the Sakila example database available for MySQL, which was originally developed by Mike Hillyer of the MySQL AB documentation team. 
This project is designed to help database administrators to decide which database to use for development of new products
The user can run the same SQL against different kind of databases and compare the performance

License: BSD
Copyright DB Software Laboratory
http://www.etl-tools.com

*/

DROP DATABASE sakila;
CREATE DATABASE sakila;

CREATE ROW TYPE customer_t (
	customer_id INT,
	store_id INT,
	first_name VARCHAR(45),
	last_name VARCHAR(45),
	email VARCHAR(50),
	address_id INT,
	active CHAR(1),
	create_date DATETIME YEAR TO FRACTION(5),
	last_update DATETIME YEAR TO FRACTION(5)
);

CREATE FUNCTION lastupdate() RETURNING DATETIME YEAR TO SECOND;
	RETURN CURRENT;
END FUNCTION;

CREATE FUNCTION init_concat (dummy VARCHAR(255))
   RETURNING LVARCHAR(16000);
   RETURN "";
END FUNCTION;

CREATE FUNCTION iter_concat (result LVARCHAR(16000), value VARCHAR(255))
   RETURNING LVARCHAR(16000);
   IF result = "" THEN
	RETURN value;
   ELSE
	RETURN result || ", " || value;
   END IF;
END FUNCTION;

CREATE FUNCTION combine_concat (partial1 LVARCHAR(16000), partial2 LVARCHAR(16000))
   RETURNING LVARCHAR(16000);
   RETURN partial1 || ", " || partial2;
END FUNCTION;

CREATE FUNCTION final_concat (final LVARCHAR(16000))
   RETURNING LVARCHAR(16000);
   RETURN final;
END FUNCTION;

CREATE AGGREGATE group_concat WITH (
	INIT=init_concat,
	ITER=iter_concat,
	COMBINE=combine_concat,
	FINAL=final_concat
);

--
-- Table structure for table actor
--
--DROP TABLE actor;

CREATE TABLE actor (
  actor_id INT NOT NULL ,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (actor_id) CONSTRAINT pk_actor
)
;

CREATE  INDEX idx_actor_last_name ON actor(last_name)
;
 
CREATE TRIGGER actor_trigger_ai
INSERT ON actor
FOR EACH ROW
	(
		EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER actor_trigger_au
UPDATE ON actor
FOR EACH ROW
	(
		EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table country
--

CREATE TABLE country (
  country_id INT NOT NULL,
  country VARCHAR(50) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5),
  PRIMARY KEY  (country_id) CONSTRAINT pk_country
)
;

CREATE TRIGGER country_trigger_ai
INSERT ON country
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER country_trigger_au
UPDATE ON country
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table city
--

CREATE TABLE city (
  city_id INT NOT NULL,
  city VARCHAR(50) NOT NULL,
  country_id INT NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (city_id) CONSTRAINT pk_city,
  FOREIGN KEY (country_id) REFERENCES country (country_id) CONSTRAINT fk_city_country 
)
;

CREATE TRIGGER city_trigger_ai INSERT ON city
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER city_trigger_au UPDATE ON city
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table address
--

CREATE TABLE address (
  address_id INT NOT NULL,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id INT  NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (address_id) CONSTRAINT pk_address,
  FOREIGN KEY (city_id) REFERENCES city (city_id) CONSTRAINT fk_address_city 
)
;

CREATE TRIGGER address_trigger_ai INSERT ON address
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER address_trigger_au UPDATE ON address
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table language
--

CREATE TABLE language (
  language_id INT NOT NULL ,
  name CHAR(20) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY (language_id) CONSTRAINT pk_language
)
;

CREATE TRIGGER language_trigger_ai INSERT ON language
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER language_trigger_au UPDATE ON language
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table category
--

CREATE TABLE category (
  category_id INT NOT NULL,
  name VARCHAR(25) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (category_id) CONSTRAINT pk_category
);

CREATE TRIGGER category_trigger_ai INSERT ON category
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER category_trigger_au UPDATE ON category
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table staff
--

CREATE TABLE staff (
  staff_id INT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  address_id INT NOT NULL,
  picture BLOB DEFAULT NULL,
  email VARCHAR(50) DEFAULT NULL,
  store_id INT NOT NULL,
  active SMALLINT DEFAULT 1 NOT NULL,
  username VARCHAR(16) NOT NULL,
  password VARCHAR(40) DEFAULT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (staff_id) CONSTRAINT pk_staff,
  FOREIGN KEY (address_id) REFERENCES address (address_id) CONSTRAINT fk_staff_address
)
;

CREATE TRIGGER staff_trigger_ai INSERT ON staff
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER staff_trigger_au UPDATE ON staff
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
--
-- Table structure for table store
--

CREATE TABLE store (
  store_id INT NOT NULL,
  manager_staff_id INT NOT NULL,
  address_id INT NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (store_id) CONSTRAINT pk_store,
  FOREIGN KEY (manager_staff_id) REFERENCES staff (staff_id) CONSTRAINT fk_store_staff,
  FOREIGN KEY (address_id) REFERENCES address (address_id) CONSTRAINT fk_store_address
)
;

CREATE TRIGGER store_trigger_ai INSERT ON store
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER store_trigger_au UPDATE ON store
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

-- Circular referential constraints require this

ALTER TABLE staff ADD CONSTRAINT FOREIGN KEY (store_id) REFERENCES store (store_id) CONSTRAINT fk_staff_store;

--
-- Table structure for table customer
--

CREATE TABLE customer (
  customer_id INT NOT NULL,
  store_id INT NOT NULL,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(50) DEFAULT NULL,
  address_id INT NOT NULL,
  active CHAR(1) DEFAULT 'Y' NOT NULL,
  create_date DATETIME YEAR TO FRACTION(5) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (customer_id) CONSTRAINT pk_customer,
  FOREIGN KEY (store_id) REFERENCES store (store_id) CONSTRAINT fk_customer_store,
  FOREIGN KEY (address_id) REFERENCES address (address_id) CONSTRAINT fk_customer_address
)
;

CREATE  INDEX idx_customer_last_name ON customer(last_name)
;

CREATE TRIGGER customer_trigger_ai INSERT ON customer
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER customer_trigger_au UPDATE ON customer
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table film
--

CREATE TABLE film (
  film_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255) DEFAULT NULL,
  release_year VARCHAR(4) DEFAULT NULL,
  language_id INT NOT NULL,
  original_language_id INT DEFAULT NULL,
  rental_duration SMALLINT  DEFAULT 3 NOT NULL,
  rental_rate DECIMAL(4,2) DEFAULT 4.99 NOT NULL,
  length SMALLINT DEFAULT NULL,
  replacement_cost DECIMAL(5,2) DEFAULT 19.99 NOT NULL,
  rating VARCHAR(10) DEFAULT 'G',
  special_features VARCHAR(100) DEFAULT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (film_id) CONSTRAINT pk_film,
  CHECK(special_features IS NULL OR
  	special_features LIKE '%Trailers%' OR
	special_features LIKE '%Commentaries%' OR
	special_features LIKE '%Deleted Scenes%' OR
	special_features LIKE '%Behind the Scenes%') CONSTRAINT check_special_features,
  CHECK(rating in ('G','PG','PG-13','R','NC-17')) CONSTRAINT check_special_rating,
  FOREIGN KEY (language_id) REFERENCES language (language_id) CONSTRAINT fk_film_language,
  FOREIGN KEY (original_language_id) REFERENCES language (language_id) CONSTRAINT fk_film_language_original
)
;

CREATE TRIGGER film_trigger_ai INSERT ON film
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER film_trigger_au UPDATE ON film
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table film_actor
--

CREATE TABLE film_actor (
  actor_id INT NOT NULL,
  film_id  INT NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (actor_id,film_id) CONSTRAINT pk_film_actor,
  FOREIGN KEY (actor_id) REFERENCES actor (actor_id) CONSTRAINT fk_film_actor_actor,
  FOREIGN KEY (film_id) REFERENCES film (film_id) CONSTRAINT fk_film_actor_film
)
;

CREATE TRIGGER film_actor_trigger_ai INSERT ON film_actor
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER film_actor_trigger_au UPDATE ON film_actor
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;


--
-- Table structure for table film_category
--

CREATE TABLE film_category (
  film_id INT NOT NULL,
  category_id INT  NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY (film_id, category_id) CONSTRAINT pk_film_category,
  FOREIGN KEY (film_id) REFERENCES film (film_id) CONSTRAINT fk_film_category_film,
  FOREIGN KEY (category_id) REFERENCES category (category_id) CONSTRAINT fk_film_category_category
)
;

CREATE TRIGGER film_category_trigger_ai INSERT ON film_category
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER film_category_trigger_au UPDATE ON film_category
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

--
-- Table structure for table film_text
--

CREATE TABLE film_text (
  film_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  PRIMARY KEY  (film_id) CONSTRAINT pk_film_text
)
;

--
-- Table structure for table inventory
--

CREATE TABLE inventory (
  inventory_id INT NOT NULL,
  film_id INT NOT NULL,
  store_id INT NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (inventory_id) CONSTRAINT pk_inventory,
  FOREIGN KEY (store_id) REFERENCES store (store_id) CONSTRAINT fk_inventory_store,
  FOREIGN KEY (film_id) REFERENCES film (film_id) CONSTRAINT fk_inventory_film
)
;

CREATE TRIGGER inventory_trigger_ai INSERT ON inventory
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER inventory_trigger_au UPDATE ON inventory
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;


--
-- Table structure for table payment
--

CREATE TABLE payment (
  payment_id INT NOT NULL,
  customer_id INT  NOT NULL,
  staff_id INT NOT NULL,
  rental_id INT DEFAULT NULL,
  amount DECIMAL(5,2) NOT NULL,
  payment_date DATETIME YEAR TO FRACTION(5) NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY  (payment_id) CONSTRAINT pk_payment,
  FOREIGN KEY (customer_id) REFERENCES customer (customer_id) CONSTRAINT fk_payment_customer,
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id) CONSTRAINT fk_payment_staff
)
;

CREATE TRIGGER payment_trigger_ai INSERT ON payment
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;
 
CREATE TRIGGER payment_trigger_au UPDATE ON payment
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

CREATE TABLE rental (
  rental_id INT NOT NULL,
  rental_date DATETIME YEAR TO FRACTION(5) NOT NULL,
  inventory_id INT  NOT NULL,
  customer_id INT  NOT NULL,
  return_date DATETIME YEAR TO FRACTION(5) DEFAULT NULL,
  staff_id INT  NOT NULL,
  last_update DATETIME YEAR TO FRACTION(5) NOT NULL,
  PRIMARY KEY (rental_id) CONSTRAINT pk_rental,
  FOREIGN KEY (staff_id) REFERENCES staff (staff_id) CONSTRAINT fk_rental_staff,
  FOREIGN KEY (inventory_id) REFERENCES inventory (inventory_id) CONSTRAINT fk_rental_inventory,
  FOREIGN KEY (customer_id) REFERENCES customer (customer_id) CONSTRAINT fk_rental_customer
)
;
CREATE UNIQUE INDEX   idx_rental_uq  ON rental (rental_date,inventory_id,customer_id)
;

CREATE TRIGGER rental_trigger_ai INSERT ON rental
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

CREATE TRIGGER rental_trigger_au UPDATE ON rental
FOR EACH ROW
	(
	EXECUTE FUNCTION lastupdate() INTO last_update
	)
;

ALTER TABLE payment ADD CONSTRAINT FOREIGN KEY (rental_id) REFERENCES rental (rental_id) CONSTRAINT fk_payment_rental;

--
-- View structure for view customer_list
--

CREATE VIEW customer_list (id, name, address, zip_code, phone, city, country, notes, sid)
AS
SELECT cu.customer_id AS ID,
       cu.first_name||' '||cu.last_name AS name,
       a.address AS address,
       a.postal_code AS zip_code,
       a.phone AS phone,
       city.city AS city,
       country.country AS country,
       case when cu.active=1 then 'active' else '' end AS notes,
       cu.store_id AS SID
FROM customer AS cu JOIN address AS a ON cu.address_id = a.address_id JOIN city ON a.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
;
--
-- View structure for view film_list
--

CREATE VIEW film_list (fid, title, description, category, price, length, rating, actors)
AS
SELECT film.film_id AS FID,
       film.title AS title,
       film.description AS description,
       category.name AS category,
       film.rental_rate AS price,
       film.length AS length,
       film.rating AS rating,
       actor.first_name||' '||actor.last_name AS actors
FROM category LEFT JOIN film_category ON category.category_id = film_category.category_id LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id
    JOIN actor ON film_actor.actor_id = actor.actor_id
;

--
-- View structure for view `nicer_but_slower_film_list`
--

CREATE VIEW nicer_but_slower_film_list (FID, title, description, category, price, length, rating, actors)
AS
SELECT film.film_id AS FID, film.title AS title, film.description AS description, category.name AS category, film.rental_rate AS price,
        film.length AS length, film.rating AS rating,
        GROUP_CONCAT(INITCAP(actor.first_name)::VARCHAR(255) || ' ' || INITCAP(actor.last_name)::VARCHAR(255)) AS actors
FROM category LEFT JOIN film_category ON category.category_id = film_category.category_id LEFT JOIN film ON film_category.film_id = film.film_id
        JOIN film_actor ON film.film_id = film_actor.film_id
        JOIN actor ON film_actor.actor_id = actor.actor_id
GROUP BY film.film_id, film.title, film.description, film.rental_rate, film.length, film.rating, category.name;

--
-- View structure for view staff_list
--

CREATE VIEW staff_list (id, name, address, zip_code, phone, city, country, sid)
AS
SELECT s.staff_id AS ID,
       s.first_name||' '||s.last_name AS name,
       a.address AS address,
       a.postal_code AS zip_code,
       a.phone AS phone,
       city.city AS city,
       country.country AS country,
       s.store_id AS SID
FROM staff AS s JOIN address AS a ON s.address_id = a.address_id JOIN city ON a.city_id = city.city_id
    JOIN country ON city.country_id = country.country_id
;
--
-- View structure for view sales_by_store
--

CREATE VIEW sales_by_store (id, store, manager, total_sales)
AS
SELECT
  s.store_id AS id
 ,c.city||','||cy.country AS store
 ,m.first_name||' '||m.last_name AS manager
 ,SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN store AS s ON i.store_id = s.store_id
INNER JOIN address AS a ON s.address_id = a.address_id
INNER JOIN city AS c ON a.city_id = c.city_id
INNER JOIN country AS cy ON c.country_id = cy.country_id
INNER JOIN staff AS m ON s.manager_staff_id = m.staff_id
GROUP BY  
  1
, 2
, 3
;
--
-- View structure for view sales_by_film_category
--
-- Note that total sales will add up to >100% because
-- some titles belong to more than 1 category
--

CREATE VIEW sales_by_film_category (category, total_sales)
AS
SELECT
c.name AS category
, SUM(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.rental_id
INNER JOIN inventory AS i ON r.inventory_id = i.inventory_id
INNER JOIN film AS f ON i.film_id = f.film_id
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
GROUP BY c.name
;

--
-- View structure for view actor_info
--

CREATE VIEW actor_info(actor_id, first_name, last_name, film_info) AS
	SELECT a.actor_id, a.first_name, a.last_name,
		group_concat(DISTINCT
			(((c.name)::varchar(255) || ': '::varchar(255)) || (
					SELECT group_concat((f.title)::varchar(255)) AS group_concat
					FROM ((film f JOIN film_category fc ON ((f.film_id = fc.film_id)))
						JOIN film_actor fa ON ((f.film_id = fa.film_id)))
					WHERE ((fc.category_id = c.category_id) AND (fa.actor_id = a.actor_id))
					GROUP BY fa.actor_id)
			)
		) AS film_info
	FROM (((actor a LEFT JOIN film_actor fa ON ((a.actor_id = fa.actor_id)))
			LEFT JOIN film_category fc ON ((fa.film_id = fc.film_id)))
			LEFT JOIN category c ON ((fc.category_id = c.category_id)))
	GROUP BY a.actor_id, a.first_name, a.last_name;


--
-- Procedure structure for procedure `rewards_report`
--

CREATE PROCEDURE rewards_report (
    min_monthly_purchases INT,
    min_dollar_amount_purchased DECIMAL(10,2)
) RETURNING ROW
-- RETURNING INT, INT, VARCHAR(45), VARCHAR(45), VARCHAR(50), INT, CHAR(1), DATETIME YEAR TO FRACTION(5), DATETIME YEAR TO FRACTION(5)

    DEFINE last_month_start DATE;
    DEFINE last_month_end DATE;
    DEFINE cust customer_t;
	-- customer_id INT NOT NULL,
	-- store_id INT NOT NULL,
	-- first_name VARCHAR(45) NOT NULL,
	-- last_name VARCHAR(45) NOT NULL,
	-- email VARCHAR(50) DEFAULT NULL,
	-- address_id INT NOT NULL,
	-- active CHAR(1) DEFAULT 'Y' NOT NULL,
	-- create_date DATETIME YEAR TO FRACTION(5) NOT NULL,
	-- last_update DATETIME YEAR TO FRACTION(5) NOT NULL
    -- END RECORD;

    /* Some sanity checks... */
    IF min_monthly_purchases = 0 THEN
        RAISE EXCEPTION -746, 0, 'Minimum monthly purchases parameter must be > 0';
        RETURN 0;
    END IF;
    IF min_dollar_amount_purchased = 0.00 THEN
        RAISE EXCEPTION -746, 0, 'Minimum monthly dollar amount purchased parameter must be > $0.00';
        RETURN 0;
    END IF;

    /* Determine start and end time periods */
    LET last_month_start = TODAY - 1 UNITS MONTH;
    LET last_month_start = MDY(MONTH(last_month_start), 1, YEAR(last_month_start));
    LET last_month_end = LAST_DAY(last_month_start);

    /*
        Create a temporary storage area for
        Customer IDs.
    */
    CREATE TEMP TABLE tmpCustomer (customer_id INT NOT NULL PRIMARY KEY);

    /*
        Find all customers meeting the
        monthly purchase requirements
    */
    INSERT INTO tmpCustomer (customer_id)
    SELECT p.customer_id
    FROM payment AS p
    WHERE DATE(p.payment_date) BETWEEN last_month_start AND last_month_end
    GROUP BY customer_id
    HAVING SUM(p.amount) > min_dollar_amount_purchased
    AND COUNT(customer_id) > min_monthly_purchases;

    /* Populate OUT parameter with count of found customers */
    SELECT COUNT(*) FROM tmpCustomer INTO count_rewardees;

    /*
        Output ALL customer information of matching rewardees.
        Customize output as needed.
    */

    FOREACH
	SELECT c.* INTO cust
	FROM tmpCustomer t, customer c
	WHERE t.customer_id = c.customer_id
	RETURN cust WITH RESUME;
    END FOREACH;

    /* Clean up */
    DROP TABLE tmpCustomer;
END PROCEDURE;

CREATE FUNCTION get_customer_balance(p_customer_id INT, p_effective_date DATETIME YEAR TO FRACTION(5)) RETURNING DECIMAL(5,2)

       -- OK, WE NEED TO CALCULATE THE CURRENT BALANCE GIVEN A CUSTOMER_ID AND A DATE
       -- THAT WE WANT THE BALANCE TO BE EFFECTIVE FOR. THE BALANCE IS:
       --    1) RENTAL FEES FOR ALL PREVIOUS RENTALS
       --    2) ONE DOLLAR FOR EVERY DAY THE PREVIOUS RENTALS ARE OVERDUE
       --    3) IF A FILM IS MORE THAN RENTAL_DURATION * 2 OVERDUE, CHARGE THE REPLACEMENT_COST
       --    4) SUBTRACT ALL PAYMENTS MADE BEFORE THE DATE SPECIFIED

  DEFINE v_rentfees DECIMAL(5,2); -- FEES PAID TO RENT THE VIDEOS INITIALLY
  DEFINE v_overfees INTEGER;      -- LATE FEES FOR PRIOR RENTALS
  DEFINE v_payments DECIMAL(5,2); -- SUM OF PAYMENTS MADE PREVIOUSLY

  SELECT NVL(SUM(film.rental_rate), 0) INTO v_rentfees
    FROM film, inventory, rental
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;

  SELECT NVL(
		SUM(
			CASE    WHEN ((EXTEND(rental.return_date, DAY TO DAY) - EXTEND(rental.rental_date, DAY TO DAY))::CHAR(8))::INT > film.rental_duration
				THEN ((EXTEND(rental.return_date, DAY TO DAY) - EXTEND(rental.rental_date, DAY TO DAY))::CHAR(8))::INT - film.rental_duration
				ELSE 0
				END
		), 0
	    ) INTO v_overfees
    FROM rental, inventory, film
    WHERE film.film_id = inventory.film_id
      AND inventory.inventory_id = rental.inventory_id
      AND rental.rental_date <= p_effective_date
      AND rental.customer_id = p_customer_id;


  SELECT NVL(SUM(payment.amount),0) INTO v_payments
    FROM payment
    WHERE payment.payment_date <= p_effective_date
    AND payment.customer_id = p_customer_id;

  RETURN v_rentfees + v_overfees - v_payments;
END FUNCTION;

CREATE PROCEDURE film_in_stock(p_film_id INT, p_store_id INT) RETURNING p_film_count INT
     DEFINE p_film_count INT;

     SELECT COUNT(*) INTO p_film_count
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND inventory_in_stock(inventory_id);

     RETURN p_film_count;

END PROCEDURE;

CREATE PROCEDURE film_not_in_stock(p_film_id INT, p_store_id INT) RETURNING INT
     DEFINE p_film_count INT;
     -- SELECT inventory_id
     -- FROM inventory
     -- WHERE film_id = p_film_id
     -- AND store_id = p_store_id
     -- AND NOT inventory_in_stock(inventory_id);

     SELECT COUNT(*) INTO p_film_count
     FROM inventory
     WHERE film_id = p_film_id
     AND store_id = p_store_id
     AND NOT inventory_in_stock(inventory_id);

     RETURN p_film_count;
END PROCEDURE;

CREATE FUNCTION inventory_held_by_customer(p_inventory_id INT) RETURNS INT
  DEFINE v_customer_id INT;

  FOREACH 
	  SELECT customer_id INTO v_customer_id
	  FROM rental
	  WHERE return_date IS NULL
	  AND inventory_id = p_inventory_id
	  RETURN v_customer_id WITH RESUME;
  END FOREACH;

END FUNCTION;

CREATE FUNCTION inventory_in_stock(p_inventory_id INT) RETURNS BOOLEAN
    DEFINE v_rentals INT;
    DEFINE v_out     INT;

    -- AN ITEM IS IN-STOCK IF THERE ARE EITHER NO ROWS IN THE rental TABLE
    -- FOR THE ITEM OR ALL ROWS HAVE return_date POPULATED

    SELECT COUNT(*) INTO v_rentals
    FROM rental
    WHERE inventory_id = p_inventory_id;

    IF v_rentals = 0 THEN
      RETURN 't';
    END IF;

    SELECT COUNT(rental_id) INTO v_out
    FROM inventory, rental 
    WHERE inventory.inventory_id = rental.inventory_id
    AND inventory.inventory_id = p_inventory_id
    AND rental.return_date IS NULL;

    IF v_out > 0 THEN
      RETURN 'f';
    ELSE
      RETURN 't';
    END IF;
END FUNCTION;





CREATE EXTERNAL TABLE e_payment SAMEAS payment USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_payment.unl"));
CREATE EXTERNAL TABLE e_rental SAMEAS rental USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_rental.unl"));
CREATE EXTERNAL TABLE e_customer SAMEAS customer USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_customer.unl"));
CREATE EXTERNAL TABLE e_film_category SAMEAS film_category USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_film_category.unl"));
CREATE EXTERNAL TABLE e_film_text SAMEAS film_text USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_film_text.unl"));
CREATE EXTERNAL TABLE e_film_actor SAMEAS film_actor USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_film_actor.unl"));
CREATE EXTERNAL TABLE e_inventory SAMEAS inventory USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_inventory.unl"));
CREATE EXTERNAL TABLE e_film SAMEAS film USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_film.unl"));
CREATE EXTERNAL TABLE e_category SAMEAS category USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_category.unl"));
CREATE EXTERNAL TABLE e_staff SAMEAS staff USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_staff.unl"));
CREATE EXTERNAL TABLE e_store SAMEAS store USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_store.unl"));
CREATE EXTERNAL TABLE e_actor SAMEAS actor USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_actor.unl"));
CREATE EXTERNAL TABLE e_address SAMEAS address USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_address.unl"));
CREATE EXTERNAL TABLE e_city SAMEAS city USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_city.unl"));
CREATE EXTERNAL TABLE e_country SAMEAS country USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_country.unl"));
CREATE EXTERNAL TABLE e_language SAMEAS language USING (DATAFILES ("DISK:/home/informix/sakila/informix-sakila-db/data/e_language.unl"));

