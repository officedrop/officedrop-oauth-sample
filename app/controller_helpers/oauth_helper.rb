
module OauthHelper

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
      RequestToken.from( session[:request_token_id], officedrop_consumer )
    end
  end

  def create_request_token
    token = officedrop_consumer.get_request_token( :oauth_callback => authorize_session_url )
    RequestToken.from( officedrop_consumer,
      :secret => token.secret,
      :token => token.token,
      :oauth_application_id => OauthApplication.officedrop.id
    )
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

  def http_multipart_data(params)
    crlf = "\r\n"
    body = ""
    headers = {}

    boundary = Time.now.to_i.to_s(16)

    headers["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
    params.each do |key,value|
      esc_key = OAuth::Helper.escape(key.to_s)
      body << "--#{boundary}#{crlf}"

      if value.respond_to?( :content_type ) && value.respond_to?( :original_filename )
        mime_type = MIME::Types.type_for(value.original_filename)[0] ||
          MIME::Types["application/octet-stream"][0]
        body << "Content-Disposition: form-data; name=\"#{esc_key}\"; "
        body << "filename=\"#{File.basename(value.original_filename)}\"#{crlf}"
        body << "Content-Type: #{mime_type.simplified}#{crlf*2}"
        body << value.read
      elsif value.respond_to?(:read)
        mime_type = MIME::Types.type_for(value.path)[0] || MIME::Types["application/octet-stream"][0]
        body << "Content-Disposition: form-data; name=\"#{esc_key}\"; filename=\"#{File.basename(value.path)}\"#{crlf}"
        body << "Content-Type: #{mime_type.simplified}#{crlf*2}"
        body << value.read
      else
        body << "Content-Disposition: form-data; name=\"#{esc_key}\"#{crlf*2}#{value}"
      end
    end

    body << "--#{boundary}--#{crlf*2}"
    headers["Content-Length"] = body.size.to_s

    return [ body, headers ]
  end

end