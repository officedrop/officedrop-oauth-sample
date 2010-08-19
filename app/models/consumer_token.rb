
class ConsumerToken < ActiveRecord::Base

  validates_presence_of :secret, :token

  attr_accessor :consumer

  delegate :authorize_url, :get_access_token, :to => :request_token

  def request_token    
    @request_token ||= OAuth::RequestToken.new( self.consumer, self.token, self.secret)
  end

  def access_token
    @access_token ||= OAuth::AccessToken.new( self.consumer, self.token, self.secret)
  end

  class << self

    def from( *args )
      options  = args.extract_options!
      token = if args.size == 2
        self.find_by_id( args.first )
      else
        self.new( options )
      end
      return nil if token.nil?
      token.update_attributes( options ) unless options.blank?
      token.consumer = args.last
      token
    end

  end

end