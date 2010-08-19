require 'office_drop/api/configuration'

class OfficeDrop::Api::DocumentsService

  attr_accessor :http_service

  def initialize( http_service )
    self.http_service = http_service
  end

  def list( options = {} )
    options.assert_valid_keys( :page, :per_page, :account_id )
    
  end

end