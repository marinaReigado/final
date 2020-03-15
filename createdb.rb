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
  String :price
  String :comments, text: true
end

# Insert initial (seed) data
restaurants_table = DB.from(:restaurants)

restaurants_table.insert(restaurant_name: "Cachoeira Tropical", 
                    adress: "R. João Cachoeira, 263 - Itaim Bibi, São Paulo - SP, 04535-010, Brasil")

restaurants_table.insert(restaurant_name: "Prime Dog", 
                    adress: "Rua Vergueiro, 1960 - Vila Mariana, São Paulo - SP, 04104-000, Brasil")
