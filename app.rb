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
  @keywords = Keyword.all.page(page, :per_page => 10, :order => :id.asc)
  @url = url "/keyword"
  erb :show_all
end

get "/keyword/by_updated_at" do
  page = params[:page] || 1
  @keywords = Keyword.all.page(page, :per_page => 10, :order => :updated_at.desc)
  @url = url "/keyword/by_updated_at" 
  erb :show_all
end

get "/keyword/assigned" do
  redirect to "/keyword" unless logged_in?
  page = params[:page] || 1
  @keywords = Keyword.all(:definition => {:user => current_user}).page(page, :per_page => 10, :order => :id.asc)
  @url = url "/keyword/assigned" 
  erb :show_all
end

get "/definition/:id" do
  session[:prev_page] = back
  @def = Definition.get(params[:id])
  erb :edit
end

put "/definition/:id" do
  unless logged_in?
    flash[:error] = "Zum Speichern erst anmelden!"
    redirect back
  else
    definition = Definition.get(params[:id])
    definition.user ||= current_user
    definition.translation = params[:trans]
    if definition.save
      status 201
      flash[:notice] = "Erfolgreich gespeichert."
      redirect(session[:prev_page] || (to "/keyword"))
    else 
      status 412
      flash[:error] = "Das hat nicht funktioniert..."
      redirect to "/definition/#{params[:id]}"
    end
  end
end 

post "/definition/:id/comment/new" do
  definition = Definition.get(params[:id])
  comment = params[:def_comment].strip
  unless comment.empty?
    Comment.create(:comment => comment, :author => logged_in? ? current_user.email : "Anonym", :definition => definition)
    redirect back
  else
    redirect to "/definition/#{params[:id]}"
  end
end

get "/download" do
  user_work = User.all.map{|user| user.email + "\n" + Keyword.user_keywords(user.email)}
  text = user_work.join("\n")
  attachment "user_work.txt"
  text
end

