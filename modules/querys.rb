module StaticQuery
  QUERYS = {
    search_restaurants: "SELECT restaurant_name, category, city FROM restaurant",
    unique_dishes: "SELECT DISTINCT dish_name FROM dish ORDER BY dish_name;",
    top_restaurants_visitors: "SELECT r.restaurant_name, COUNT(c.restaurant_id) AS visitors
        FROM restaurant AS r
        JOIN client_restaurant AS c ON c.restaurant_id = r.id
        GROUP BY restaurant_name
        ORDER BY visitors DESC
        LIMIT 10;",
    top_restaurants_sales: "SELECT r.restaurant_name, SUM(d.price)
        AS sales
        FROM client_restaurant AS c
        JOIN restaurant AS r ON c.restaurant_id = r.id
        JOIN dish AS d ON c.dish_id = d.id
        GROUP BY r.restaurant_name
        ORDER BY sales DESC
        LIMIT 10;",
    top_restaurants_avg_expense: "SELECT r.restaurant_name, ROUND(AVG(d.price),1)
        AS avg_expense
        FROM client_restaurant AS c
        JOIN restaurant AS r ON c.restaurant_id = r.id
        JOIN dish AS d ON c.dish_id = d.id
        GROUP BY r.restaurant_name
        ORDER BY avg_expense DESC
        LIMIT 10;",
    sales_month: "SELECT TO_CHAR(c.visit_date, 'Month') AS month,
        COUNT(d.price) AS sales
        FROM client_restaurant AS c
        JOIN dish AS d ON c.dish_id = d.id
        GROUP BY month
        ORDER BY month",
    dishes_restaurant_lower_price: "select DISTINCT ON (d.dish_name) d.dish_name, r.restaurant_name, min(d.price)
        from dish as d
        join restaurant as r on r.id=d.restaurant_id
        group by d.dish_name,d.price, r.restaurant_name
        ORDER BY d.dish_name;",
    favorite_dish: "from client_restaurant as cr
        join client as c on c.id=cr.client_id
        join dish as d on d.id=cr.dish_id"
  }.freeze
end
