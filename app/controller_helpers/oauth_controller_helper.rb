
module OauthControllerHelper

  protected

  def officedrop_consumer
    @consumer ||= OauthApplication.officedrop.consumer
  end

  def request_token
    @request_token ||= load_request_token || create_request_token
    session[:request_token_id] = @request_token.id
    @request_token
  end

  def load_request_token
    if session[:request_token_id]
      token = RequestToken.find( session[:request_token_id] )
      token.consumer = officedrop_consumer
      token
    end
  end

  def create_request_token
    token = officedrop_consumer.get_request_token( :oauth_callback => authorize_session_url )
    request_token = RequestToken.create!(
      :token => token.token,
      :secret => token.secret,
      :oauth_application_id => OauthApplication.officedrop.id,
      :consumer => officedrop_consumer
    )
    request_token
  end

  def setup_access_token
    token = nil
    begin
      token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    rescue OAuth::Unauthorized
      session[:request_token_id] = nil
      return
    end

    response = get( '/user', :access_token => token )
    user = User.find_by_officedrop_id( response['id'] )

    unless user
      user = User.create!( :officedrop_id => response['id'] )
    end

    self.current_user = user

    access_token = user.access_token || user.build_access_token
    access_token.update_attributes(
      :token => token.token,
      :secret => token.secret,
      :verifier => params[:oauth_verifier],
      :user_id => user.id,
      :oauth_application_id => OauthApplication.officedrop.id
    )
    access_token
  end

  def access_token
    if logged_in?
      token = AccessToken.first( :conditions => {:user_id => current_user.id} )
      token.consumer = officedrop_consumer
      token.access_token
    end
  end

end