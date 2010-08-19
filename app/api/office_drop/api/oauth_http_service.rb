
class OfficeDrop::Api::OauthHttpService

  attr_accessor :configuration, :access_token

  def initialize( access_token, configuration = OfficeDrop::Api::Configuration.current_configuration )
    self.access_token  = access_token
    self.configuration = configuration
  end

  [ :get, :post, :put, :delete ].each do |method|
    class_eval( %Q!

  def #{method}( path, parameters = {} )
    self.access_token.#{method}( clean_path("\#{self.configuration[:server]}/ze/api/\#{path}") )
  end

      ! )
  end

  def clean_path( path )
    path.gsub!('//', '/')
    path
  end

end