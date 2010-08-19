
class OfficeDrop::Api::Facade

  attr_accessor :http_service, :configuration

  def initialize( http_service, configuration = OfficeDrop::Api::Configuration.current_configuration )
    self.http_service  = http_service
    self.configuration = configuration
  end

  def current_user
    
  end

end