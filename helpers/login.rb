helpers do  

  def logged_in?
    User.get(session[:user_id])
  end

  def log_in(params)
    user = User.authenticate(params)
    user ? session[:user_id] = user.id : false
  end

  def log_out
    session[:user_id] = nil
  end

  def current_user
    if logged_in?
      User.get(session[:user_id])
    else
      nil
    end
  end

end
