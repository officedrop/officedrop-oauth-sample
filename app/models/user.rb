class User < ActiveRecord::Base

  belongs_to :request_token
  belongs_to :access_token

end