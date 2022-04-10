require "pg"
require "csv"

# Append to connect to DB
DB = PG.connect(dbname: "insight")

def insert(table, data, unique_column = nil)
  entity = nil

  entity = find(table, unique_column, data[unique_column]) if unique_column

  entity ||=  DB.exec(%[INSERT INTO #{table} (#{data.keys.join(', ')})
              VALUES (#{data.values.map { |value| "'#{value.gsub("'", "''")}'" }.join(', ')})
              RETURNING *;]).first

  entity
end

def find(table, column, value)
  DB.exec(%(
    SELECT * FROM #{table}
    WHERE #{column} = '#{value.gsub("'", "''")}';

    )).first
end
# value.gsub("'","''") (linea 22)

# for each row to books

CSV.foreach("data.csv", headers: true) do |row|
  client_data = {
    "client_name" => row["client_name"], "age" => row["age"],
    "gender" => row["gender"],
    "occupation" => row["occupation"],
    "nationality" => row["nationality"]
  }
  client = insert("client", client_data, "client_name")

  restaurant_data = {
    "restaurant_name" => row["restaurant_name"],
    "category" => row["category"],
    "city" => row["city"],
    "address" => row["address"]
  }
  restaurant = insert("restaurant", restaurant_data, "restaurant_name")

  dish_data = {
    "dish_name" => row["dish"],
    "price" => row["price"],
    "restaurant_id" => restaurant["id"]
  }
  dish = insert("dish", dish_data)

  client_restaurant_data = {
    "visit_date" => row["visit_date"], "client_id" => client["id"],
    "dish_id" => dish["id"], "restaurant_id" => restaurant["id"]
  }
  insert("client_restaurant", client_restaurant_data)
end
