# Set up for the application and database. DO NOT CHANGE. #############################
require "sequel"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB = Sequel.connect(connection_string)                                                #
#######################################################################################

# Database schema - this should reflect your domain model
DB.create_table! :restaurants do
  primary_key :id
  String :restaurant_name
  String :adress
end
DB.create_table! :users do
  primary_key :id
  String :user_name
  String :email
  String :password
end
DB.create_table! :reviews do
  primary_key :id
  foreign_key :restaurant_id
  foreign_key :user_id
  Boolean :vegan
  Float :taste
  Float :cleanliness
  Float :waiting_time
  Float :staff
  Float :price
  String :comments, text: true
end

# Insert initial (seed) data
restaurants_table = DB.from(:restaurants)
reviews_table = DB.from(:reviews)

restaurants_table.insert(id: 1,
                    restaurant_name: "Cachoeira Tropical", 
                    adress: "R. João Cachoeira, 263 - Itaim Bibi, São Paulo - SP, 04535-010, Brasil")

restaurants_table.insert(id:2,
                    restaurant_name: "Prime Dog", 
                    adress: "Rua Vergueiro, 1960 - Vila Mariana, São Paulo - SP, 04104-000, Brasil")

reviews_table.insert(restaurant_id:1,
                    user_id:1,
                    vegan: 1, 
                    taste: 5,
                    cleanliness:4,
                    waiting_time: 4,
                    staff: 3,
                    price: 20,
                    comments: 'Very good!')

reviews_table.insert(restaurant_id:1,
                    user_id:2,
                    vegan: 1, 
                    taste: 4,
                    cleanliness:5,
                    waiting_time: 3,
                    staff: 3,
                    price: 30,
                    comments: 'Excelent!')

reviews_table.insert(restaurant_id:2,
                    user_id:1,
                    vegan: 1, 
                    taste: 4,
                    cleanliness:3,
                    waiting_time: 5,
                    staff: 5,
                    price: 10,
                    comments: 'Perfect!')

reviews_table.insert(restaurant_id:2,
                    user_id:2,
                    vegan: 1, 
                    taste: 3,
                    cleanliness:5,
                    waiting_time: 4,
                    staff: 5,
                    price: 20,
                    comments: 'Cheap!')