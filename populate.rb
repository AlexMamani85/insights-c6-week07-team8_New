require "pg"
require "csv"

# Append to connect to DB
DB = PG.connect(dbname: "insight") 

def insert(table, data, unique_column = nil)
  entity = nil

  entity = find(table, unique_column, data[unique_column]) if (unique_column)
  
  entity ||=  DB.exec(%[INSERT INTO #{table} (#{data.keys.join(', ')})
              VALUES (#{data.values.map { |value| "'#{value.gsub("'","''")}'"}.join(", ")})
              RETURNING *;]).first

  entity
end

def find(table, column, value)
  DB.exec(%[
    SELECT * FROM #{table} 
    WHERE #{column} = '#{value.gsub("'","''")}'; 
    ]).first
end

# for each row to books
CSV.foreach("data.csv", headers: true) do |row|

#dt: client_restaurant,  dish,  restaurant,  client

    client_restaurant_data = {
    "visit_date" => row["visit_date"],
    "client_id" => client["id"],
    "dish_id" => dish["id"],
    "restaurant_id" => restaurant["id"]
  }
  client_restaurant = insert("client_restaurants", client_restaurant_data, "visit_date")

  dish_data = {
    "dish_name" => row["dish"],
    "price" => row["price"],
    "restaurant_id" => restaurant["id"]
  }
  publisher = insert("dishes", dish_data, "name")

  client_data = {
    "client_name" => row["client_name"],
    "age" => row["age"],
    "gender" => row["gender"],
    "occupation" => row["occupation"],
    "nationality" => row["nationality"]
  }
  book = insert("clients", client_data, "client_name")

  restaurant_data = {
    "restaurant_name" => row["restaurant_name"],
    "category" => row["category"],
    "city" => row["city"],
    "address" => row["address"]
  }
  insert("books_genres", restaurant_data, "restaurant_name")
#   en book_genre no habia 3er elemento en insert 
end