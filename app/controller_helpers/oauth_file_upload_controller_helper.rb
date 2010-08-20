
module OauthFileUploadControllerHelper

  protected

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