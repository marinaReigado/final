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

get "/restaurants/:id/review/new" do
    puts "params: #{params}"
    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    pp @restaurant


    view "new_review"
end

post "/restaurants/:id/review/create" do
    puts "params: #{params}"

    @restaurant = restaurants_table.where(id: params[:id]).to_a[0]
    reviews_table.insert(
        restaurant_id: @restaurant[:id],
        #user_id: session["user_id"],
        taste: params["taste"],
        cleanliness: params["cleanliness"],
        waiting_time: params["waiting_time"],
        staff: params["staff"],
        price: params["price"],
        comments: params["comments"],
        vegan: params["vegan"]
    )
    view "create_review"
end