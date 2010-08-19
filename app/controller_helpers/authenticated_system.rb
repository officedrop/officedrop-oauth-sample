
module AuthenticatedSystem

  protected

  def current_user
    if @current_user != false
      @current_user ||= session[:user_id].blank? ? false : User.find_by_id( session[:user_id] )
    end
    @current_user
  end

  def current_user=( user )
    session[:user_id] = user.id
    @current_user = user
  end

  def logged_in?
    current_user
  end

  def login_required
    logged_in? || authentication_needed
  end

  def authentication_needed
    flash[:error] = 'You must be logged in to view that'
    redirect_to session_path
  end

end