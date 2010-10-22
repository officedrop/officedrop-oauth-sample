
class OauthApplication < ActiveRecord::Base

  validates_presence_of :name, :secret, :key
  validates_uniqueness_of :name

  has_many :consumer_tokens

  def consumer
    @consumer ||= OAuth::Consumer.new( self.key,
      self.secret,
      :site => self.site,
      :request_token_path => self.request_token_path,
      :access_token_path => self.access_token_path,
      :authorize_path => self.authorize_path
      )
  end

  class << self

    def officedrop
      OauthApplication.find_by_name!( 'officedrop' )
    end

  end

end