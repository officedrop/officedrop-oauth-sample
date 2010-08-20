class User < ActiveRecord::Base

  belongs_to :access_token

end