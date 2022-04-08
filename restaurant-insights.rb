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

def search_restaurants(param) #top_publishers
  #List of restaurants included in the research filter by ['' | category=string | city=string]"

  column, value = param.split("=") unless param.nil?

  case param
  when ""

    result = @db.exec(%[
      select * from restaurant;
    ])
  when "category"

    result = @db.exec(%[
      select * from restaurant where category like INITCAP('%#{value}%'); 
    ])
  when "city"

    result = @db.exec(%[
      select * from restaurant where city like INITCAP('%#{value}%');
    ])
    
  end
  puts(result)
  table = Terminal::Table.new
  table.title = "List of restaurants included in the research filter by #{column} = #{value}"
  table.headings = result.fields
  table.rows = result.values
  puts table

end

def unique_dishes


end

def distribution_clients(param)


end

def top_restaurants_visitors


end

def top_restaurants_sales


end

def top_restaurants_avg_expense #of their clients


end

def avg_consumer_expense(param) #


end

def sales_month(param)


end

def dishes_restaurant_lower_price


end

def favorite_dish(param)


end


=begin 
  def top_publishers
    result = @db.exec("
      SELECT * 
      FROM publishers 
      ORDER BY annual_revenue DESC
      LIMIT 5;"
    )
    
    table = Terminal::Table.new
    table.title = "Top Publishers by Annual Revenue"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
  
  def count_books(param)
    case param
    when "author"
      result = @db.exec(%[
        SELECT  a.name AS Author, COUNT(*) AS count_books
        FROM books AS b
        JOIN authors AS a ON b.author_id = a.id
        GROUP BY author
        ORDER BY count_books DESC;
      ])
    when "publisher"
      result = @db.exec(%[
        SELECT  p.name AS publisher, COUNT(*) AS count_books
        FROM books AS b
        JOIN publishers AS p ON b.publisher_id = p.id
        GROUP BY publisher
        ORDER BY count_books DESC;
      ])
    when "genre"
      result = @db.exec(%[
        SELECT  g.name AS genre, COUNT(*) AS count_books
        FROM books AS b
        JOIN books_genres AS bg ON b.id = bg.book_id
        JOIN genres AS g ON bg.genre_id = g.id
        GROUP BY genre
        ORDER BY count_books DESC;
      ])
    end

    table = Terminal::Table.new
    table.title = "Count Books"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end
  
  def search_books(param)
    column_ref = {
      "title" => "title",
      "author" => "authors.name",
      "publisher" => "publishers.name"
    }

    column, value = param.split("=")
    column = column_ref[column]

    result = @db.exec(%[
      SELECT 
        books.id, 
        books.title, 
        books.pages, 
        authors.name AS author, 
        publishers.name AS publisher
      FROM books
      JOIN authors ON books.author_id = authors.id
      JOIN publishers ON books.publisher_id = publishers.id
      WHERE LOWER(#{column}) LIKE LOWER('%#{value}%');
    ])

    table = Terminal::Table.new
    table.title = "Search Books"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end

  def other_methods(param)
    column_ref = {
      "title" => "title",
      "author" => "authors.name",
      "publisher" => "publishers.name"
    }

    column, value = param.split("=")
    column = column_ref[column]

    result = @db.exec(%[
      SELECT 
        books.id, 
        books.title, 
        books.pages, 
        authors.name AS author, 
        publishers.name AS publisher
      FROM books
      JOIN authors ON books.author_id = authors.id
      JOIN publishers ON books.publisher_id = publishers.id
      WHERE LOWER(#{column}) LIKE LOWER('%#{value}%');
    ])

    table = Terminal::Table.new
    table.title = "Search Books"
    table.headings = result.fields
    table.rows = result.values
    puts table
  end

  def other_methods_2(param)

    column, value = param.split("=")
    column = column_ref[column]

    result = @db.exec(%[
      SELECT 
        books.id, 
        books.title, 
        books.pages, 
        authors.name AS author, 
        publishers.name AS publisher
      FROM books
      JOIN authors ON books.author_id = authors.id
      JOIN publishers ON books.publisher_id = publishers.id
      WHERE LOWER(#{column}) LIKE LOWER('%#{value}%');
    ])

  end

=end
end

app = InsightApp.new
app.start