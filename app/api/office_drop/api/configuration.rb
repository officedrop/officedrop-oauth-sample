
class OfficeDrop::Api::Configuration

  DEFAULTS = {
    :server => "https://www.officedrop.com/"
  }

  class << self

    def current_configuration
      @current_configuration ||= DEFAULTS
    end

    def current_configuration=( config )
      config.assert_valid_keys(:server, :autentication_object)
      @current_configuration = config
    end

  end

end