
module OauthCallsControllerHelper

  protected

  def officedrop_host
    OauthApplication.officedrop.site
  end

  def build_url( path )
    result = "#{officedrop_host}/ze/api#{path}.json"
    result
  end

  def get( path, options = {}, headers = {} )
    http_action( :get, path, options, headers )
  end

  def post( path, options = {}, headers = {} )
    http_action( :post, path, options, headers )
  end

  def http_action( method, path, parameters = {}, headers = {} )
    token    = self.access_token || parameters.delete(:access_token)
    response = case method
    when :get, :delete
      parameters.delete_if { |k,v| v.blank? }
      query_string = parameters.map { |k,v| "#{k}=#{uri_escape(v)}" }.join( "&" )
      token.send( method, build_url( path ) << '?' << query_string, headers )
    else
      token.send( method, build_url( path ), parameters, headers )
    end
    JSON.parse(response.body)
  end

  def uri_escape( value )
    URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

end