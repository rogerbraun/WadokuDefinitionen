require "digest/sha1"

require "./helpers/login.rb"
require "./models/user.rb"
require "./models/definition.rb"
require "./config/db.rb"

enable :sessions
use Rack::Flash


get "/login" do
  erb :login
end

post "/login" do
  user = log_in(params)
  if user then
    flash[:notice] = "Erfolgreich angemeldet!"
    redirect to "/"
  else
    flash[:error] = "Username oder Passwort falsch."
    redirect to "/login"
  end
end

get "/logout" do
  log_out
  flash[:notice] = "Erfolgreich abgemeldet!" 
  redirect to "/"
end

get "/register" do
  erb :register
end

post "/register" do
  user = User.new
  user.email = params[:email]
  user.password = params[:password]
  if user.save then
    flash[:notice] = "Erfolgreich registriert"
    session[:user_id] = user.id
    redirect to "/" 
  else
    flash[:error] = "Das hat nicht funktioniert..."
    redirect to "/register" 
  end
end

get "/" do
  erb :index
end
