1. SELECT * FROM restaurant;
1. SELECT * FROM restaurant where category = 'query';
1. SELECT * FROM restaurant where city = 'query';

2. SELECT dish_name
   FROM (SELECT dish_name, COUNT(dish_name) 
   FROM dish GROUP BY dish_name HAVING COUNT(dish_name)<2) AS dish_distinct;

3.  SELECT a.dish_name FROM dish AS a
    JOIN (SELECT dish_name,COUNT(dish_name) 
    FROM dish GROUP BY dish_name HAVING COUNT(dish_name)<2) AS b ON
    a.dish_name = b.dish_name WHERE a.dish_name='Pizza';

4. SELECT gender,COUNT(gender),ROUND(count(gender) * 100.0 / sum(count(gender)) over(),1) AS percentage 
   FROM client GROUP BY gender;

5.  SELECT r.restaurant_name, COUNT(c.restaurant_id) AS visitors
    FROM restaurant AS r
    JOIN client_restaurant AS c ON c.restaurant_id = r.id
    GROUP BY restaurant_name
    ORDER BY visitors DESC
    LIMIT 10;

6.  SELECT r.restaurant_name, SUM(d.price)
    AS sales
    FROM client_restaurant AS c
    JOIN restaurant AS r ON c.restaurant_id = r.id
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY r.restaurant_name
    ORDER BY sales DESC
    LIMIT 10;

7.  SELECT r.restaurant_name, ROUND(AVG(d.price),1)
    AS avg_expense
    FROM client_restaurant AS c
    JOIN restaurant AS r ON c.restaurant_id = r.id
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY r.restaurant_name
    ORDER BY avg_expense DESC
    LIMIT 10;

8.  SELECT TO_CHAR(c.visit_date, 'Month') AS month,
    COUNT(d.price) AS sales
    FROM client_restaurant AS c
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY month;