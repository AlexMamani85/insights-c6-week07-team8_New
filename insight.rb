require "pg"
require "terminal-table"
require_relative "modules/prompt"
require_relative "modules/querys"
class InsightApp
  include Prompt
  include StaticQuery

  def initialize
    @db = PG.connect(dbname: "insight")
  end

  def start
    print_welcome
    print_menu

    loop do
      print "> "
      action, param = gets.chomp.split
      menu_part_one(action, param)
      menu_part_two(action, param)
      break if action == "exit"
    end
  end

  def menu_part_one(action, param)
    case action
    when "1" then search_restaurants(param) # top_publishers
    when "2" then unique_dishes
    when "3" then distribution_clients(param)
    when "4" then top_restaurants_visitors
    when "5" then top_restaurants_sales
    when "menu" then print_menu
    end
  end

  def menu_part_two(action, param)
    case action
    when "6" then top_restaurants_avg_expense # of their clients
    when "7" then avg_consumer_expense(param) #
    when "8" then sales_month(param)
    when "9" then dishes_restaurant_lower_price
    when "10" then favorite_dish(param)
    end
  end

  def search_restaurants(param)
    column, value = param.split("=") unless param.nil?
    result = if column.nil?
               @db.exec(%(#{QUERYS[:search_restaurants]};))
             else
               @db.exec(%[#{QUERYS[:search_restaurants]} where #{column} like INITCAP('%#{value}%');])
             end
    print_results(result, "List of restaurants | filter by #{column} = #{value}")
  end

  # 2
  def unique_dishes
    result = @db.exec((QUERYS[:unique_dishes]).to_s)
    print_results(result, "List of dishes")
  end

  # 3
  def distribution_clients(param)
    _column, value = param.split("=") unless param.nil?
    result = @db.exec(%[SELECT #{value},COUNT(#{value}) AS count,
    CONCAT(ROUND(count(#{value}) * 100.0 / sum(count(#{value})) over(),1),'%') AS percentage
    FROM client GROUP BY #{value} ORDER BY #{value};])
    print_results(result, "Number and Distribution of Users")
  end

  def top_restaurants_visitors
    result = @db.exec((QUERYS[:top_restaurants_visitors]).to_s)
    print_results(result, "Top 10 restaurants by visitors")
  end

  def top_restaurants_sales
    result = @db.exec((QUERYS[:top_restaurants_sales]).to_s)
    print_results(result, "Top 10 restaurants by sales")
  end

  # of their clients
  def top_restaurants_avg_expense
    result = @db.exec((QUERYS[:top_restaurants_avg_expense]).to_s)
    print_results(result, "Top 10 restaurants by average expense per user")
  end

  def avg_consumer_expense(param)
    _column, value = param.split("=") unless param.nil?
    result = @db.exec(%[SELECT c.#{value}, ROUND(AVG(d.price),1) AS avg_expense
    FROM client AS c JOIN client_restaurant AS cr ON c.id = cr.client_id
    JOIN dish AS d ON d.id = cr.dish_id GROUP BY c.#{value} ORDER BY c.#{value};])
    print_results(result, "Average consumer expenses")
  end

  def sales_month(param)
    _column, value = param.split("=") unless param.nil?

    result = @db.exec(%(#{QUERYS[:sales_month]} #{value};))
    print_results(result, "Total sales by month")
  end

  # optional
  def dishes_restaurant_lower_price
    result = @db.exec((QUERYS[:dishes_restaurant_lower_price]).to_s)
    print_results(result, "list of dishes & restaurants where you can find it at a lower price")
  end

  def favorite_dish(param)
    column, value = param.split("=") unless param.nil?
    select_text = "select distinct on (c.#{column}) c.#{column}, d.dish_name #{QUERYS[:favorite_dish]}"
    result = case column
             when "age"
               @db.exec(%(#{select_text} where c.#{column} = #{value} group by c.#{column}, d.dish_name;))
             else
               @db.exec(%[#{select_text} where c.#{column}::varchar(255)
                        like INITCAP('#{value}%') group by c.#{column}, d.dish_name;])
             end
    print_results(result, "Favorite dish for #{column}=#{value}")
  end
end

app = InsightApp.new
app.start
