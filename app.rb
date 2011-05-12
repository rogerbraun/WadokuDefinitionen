require "digest/sha1"
require "digest/md5"

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
  redirect to "/keyword"
end

get "/keyword" do
  page = params[:page] || 1
  @keywords = Keyword.page(page, :per_page => 10)
  erb :show_all
end

get "/definition/:id" do
  @def = Definition.get(params[:id])
  erb :edit
end

put "/definition/:id" do
  unless logged_in?
    flash[:error] = "Zum Speichern erst anmelden!"
    redirect back
  else
    definition = Definition.get(params[:id])
    definition.update(:translation => params[:trans])
    definition.user ||= current_user
    if definition.save
      status 201
      flash[:notice] = "Erfolgreich gespeichert."
      redirect "/keyword"
    else 
      status 412
      flash[:error] = "Das hat nicht funktioniert..."
      redirect "/definition/#{params[:id]}"
    end
  end
end 


