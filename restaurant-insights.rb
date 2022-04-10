require "pg"
require "terminal-table"

class InsightApp
  def initialize
    @db = PG.connect(dbname: "insight")
  end

  def start
    print_welcome
    print_menu

    print "> "
    action, param = gets.chomp.split
 
    until action == "exit"
      case action
      when "1" then search_restaurants(param) #top_publishers
      when "2" then unique_dishes
      when "3" then distribution_clients(param)
      when "4" then top_restaurants_visitors
      when "5" then top_restaurants_sales
      when "6" then top_restaurants_avg_expense #of their clients
      when "7" then avg_consumer_expense(param) #
      when "8" then sales_month(param)
      when "9" then dishes_restaurant_lower_price
      when "10" then favorite_dish(param)
      when "menu" then print_menu
      end
      print "> "
      action, param = gets.chomp.split
    end
  end

  def print_welcome
    puts "Welcome to the Restaurants Insights!"
    puts "Write 'menu' at any moment to print the menu again and 'quit' to exit."
  end

  def print_menu
    puts "---"
    puts "1. List of restaurants included in the research filter by ['' | category=string | city=string]"
    puts "2. List of unique dishes included in the research"
    puts "3. Number and distribution (%) of clients by [group=[age | gender | occupation | nationality]]"
    puts "4. Top 10 restaurants by the number of visitors."
    puts "5. Top 10 restaurants by the sum of sales."
    puts "6. Top 10 restaurants by the average expense of their clients."
    puts "7. The average consumer expense group by [group=[age | gender | occupation | nationality]]"
    puts "8. The total sales of all the restaurants group by month [order=[asc | desc]]"
    puts "9. The list of dishes and the restaurant where you can find it at a lower price."
    puts "10. The favorite dish for [age=number | gender=string | occupation=string | nationality=string]"
    puts "---"
    puts "Pick a number from the list and an [option] if necessary"

  end

  def print_results(result,prompt)
    puts(result)
    table = Terminal::Table.new
    table.title = prompt
    table.headings = result.fields
    table.rows = result.values
    puts table
  end

def search_restaurants(param) #1
  #List of restaurants included in the research filter by ['' | category=string | city=string]"
  column = nil
  column, value = param.split("=") unless param.nil?
  select_text = "select restaurant_name, category, city from restaurant"

  if column.nil?
    result = @db.exec(%[
      #{select_text};
    ])
  else
    result = @db.exec(%[
      #{select_text} where #{column} like INITCAP('%#{value}%'); 
    ])
  end

  print_results(result,"List of restaurants included in the research filter by #{column} = #{value}")
end

def unique_dishes #2
  result = @db.exec(%[
    SELECT DISTINCT dish_name FROM dish ORDER BY dish_name;
   ])

  print_results(result,"List of dishes")

end

def distribution_clients(param) #3
  column = nil
  column, value = param.split("=") unless param.nil?
  select_text = "select restaurant_name, category, city from restaurant"
  
  result = @db.exec(%[
    SELECT #{value},COUNT(#{value}) AS cantidad,
    CONCAT(ROUND(count(#{value}) * 100.0 / sum(count(#{value})) over(),1),'%') AS percentage 
    FROM client GROUP BY #{value}
    ORDER BY #{value};
  ])
  print_results(result,"Number and Distribution of Users")
end

def top_restaurants_visitors

  result = @db.exec(%[
    SELECT r.restaurant_name, COUNT(c.restaurant_id) AS visitors
    FROM restaurant AS r
    JOIN client_restaurant AS c ON c.restaurant_id = r.id
    GROUP BY restaurant_name
    ORDER BY visitors DESC
    LIMIT 10;
  ])
  print_results(result, "Top 10 restaurants by visitors")
end

def top_restaurants_sales
  result = @db.exec(%[
    SELECT r.restaurant_name, SUM(d.price)
    AS sales
    FROM client_restaurant AS c
    JOIN restaurant AS r ON c.restaurant_id = r.id
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY r.restaurant_name
    ORDER BY sales DESC
    LIMIT 10;
  ])
  print_results(result, "Top 10 restaurants by sales")

end

def top_restaurants_avg_expense #of their clients
  result = @db.exec(%[
    SELECT r.restaurant_name, ROUND(AVG(d.price),1)
    AS avg_expense
    FROM client_restaurant AS c
    JOIN restaurant AS r ON c.restaurant_id = r.id
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY r.restaurant_name
    ORDER BY avg_expense DESC
    LIMIT 10;
  ])
  print_results(result, "Top 10 restaurants by average expense per user")

end
#The average consumer expense group by [group=[age | gender | occupation | nationality]]"
def avg_consumer_expense(param) # de 93
  #column = nil
  column, value = param.split("=") unless param.nil?
  select_text = "select restaurant_name, category, city from restaurant"
  
  result = @db.exec(%[
    select r.#{value}, ROUND(AVG(d.price), 1) AS avg_expense
    FROM client AS r
    FULL OUTER JOIN client_restaurant AS c ON c.restaurant_id = r.id
    FULL OUTER JOIN dish AS d ON c.dish_id = d.id
    GROUP BY r.#{value}
    ORDER BY r.#{value}
    ;
  ])




  print_results(result, " ")
end

def sales_month(param)
  column = nil
  column, value = param.split("=") unless param.nil?

  result = @db.exec(%[
    SELECT TO_CHAR(c.visit_date, 'Month') AS month,
    COUNT(d.price) AS sales
    FROM client_restaurant AS c
    JOIN dish AS d ON c.dish_id = d.id
    GROUP BY month
    ORDER BY month #{value};
  ])
  print_results(result, "Total sales by month")
end

def dishes_restaurant_lower_price #optional
  result = @db.exec(%[
  select DISTINCT ON (d.dish_name) d.dish_name, r.restaurant_name, min(d.price) 
  from dish as d
  join restaurant as r on r.id=d.restaurant_id
  group by d.dish_name,d.price, r.restaurant_name
  ORDER BY d.dish_name;
  ])
  print_results(result, "list of dishes & restaurants where you can find it at a lower price")
end

# 10.The favorite dish for [age=number | gender=string | occupation=string | nationality=string]"
def favorite_dish(param) #optional

  column = nil
  column, value = param.split("=") unless param.nil?
  case column
  when "age"
    result = @db.exec(%[
      select distinct on (c.#{column}) c.#{column}, d.dish_name
      from client_restaurant as cr
      join client as c on c.id=cr.client_id
      join dish as d on d.id=cr.dish_id
      where c.#{column} = #{value}
      group by c.#{column}, d.dish_name;
      ])
  else
    result = @db.exec(%[
      select distinct on (c.#{column}) c.#{column}, d.dish_name
      from client_restaurant as cr
      join client as c on c.id=cr.client_id
      join dish as d on d.id=cr.dish_id
      where c.#{column}::varchar(255) like INITCAP('#{value}%')
      group by c.#{column}, d.dish_name;
      ])
  end
    print_results(result, "Favorite dish for #{column}=#{value}")
end

end

app = InsightApp.new
app.start