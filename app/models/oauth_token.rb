
class OauthToken < ActiveRecord::Base

  validates_presence_of :secret, :token

  attr_accessor :consumer

  delegate :authorize_url, :get_access_token, :to => :request_token

  def request_token    
    @request_token ||= OAuth::RequestToken.new( self.consumer, self.token, self.secret)
  end

  def access_token
    @access_token ||= OAuth::AccessToken.new( self.consumer, self.token, self.secret)
  end

end