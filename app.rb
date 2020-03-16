# Set up for the application and database. DO NOT CHANGE. #############################
require "sinatra"                                                                     #
require "sinatra/reloader" if development?                                            #
require "sequel"                                                                      #
require "logger"                                                                      #
require "twilio-ruby"                                                                 #
require "bcrypt"                                                                      #
connection_string = ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite3"  #
DB ||= Sequel.connect(connection_string)                                              #
DB.loggers << Logger.new($stdout) unless DB.loggers.size > 0                          #
def view(template); erb template.to_sym; end                                          #
use Rack::Session::Cookie, key: 'rack.session', path: '/', secret: 'secret'           #
before { puts; puts "--------------- NEW REQUEST ---------------"; puts }             #
after { puts; }                                                                       #
#######################################################################################

restaurants_table = DB.from(:restaurants)
reviews_table = DB.from(:reviews)

get "/" do
    puts "params: #{params}"

    pp restaurants_table.all.to_a
    @restaurants = restaurants_table.all.to_a
    view "restaurants"
end

get "/restaurant/:id" do
    puts "params: #{params}"
    
    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    pp @restaurant

    @reviews = reviews_table.where(restaurant_id: @restaurant[:id]).to_a
    @taste = reviews_table.where(restaurant_id: @restaurant[:id]).avg(:taste)
    @cleanliness = reviews_table.where(restaurant_id: @restaurant[:id]).avg(:cleanliness)
    @waiting_time = reviews_table.where(restaurant_id: @restaurant[:id]).avg(:waiting_time)
    @staff = reviews_table.where(restaurant_id: @restaurant[:id]).avg(:staff)
    @price = reviews_table.where(restaurant_id: @restaurant[:id]).avg(:price)

    view "restaurant"
end

get "/restaurant/:id/reviews/new" do
    puts "params: #{params}"
    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    pp @restaurant


    view "new_review"
end