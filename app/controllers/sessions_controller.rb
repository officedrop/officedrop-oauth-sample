
class SessionsController < ApplicationController

  def show
    redirect_to request_token.authorize_url( :oauth_callback => authorize_session_path )
  end

  def authorize
    setup_access_token
    if access_token
      flash[:notice] = 'You have successfully linked your OfficeDrop.com Account'
      redirect_to documents_path
    else
      redirect_to( session_path )
    end
  end

end