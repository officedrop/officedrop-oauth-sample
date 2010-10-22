class CreateOauthConsumerTokens < ActiveRecord::Migration

  def self.up

    create_table :oauth_applications do |t|
      t.string :name, :null => false
      t.string :key, :null => false
      t.string :secret, :null => false
      t.string :site
      t.string :scheme
      t.string :http_method
      t.string :request_token_path
      t.string :access_token_path
      t.string :authorize_path
    end

    add_index :oauth_applications, :name

    OauthApplication.reset_column_information

    OauthApplication.create!(
      :name => 'officedrop',
      :key => "c2FDDdoAjQ1fQIXH228h",
      :secret => "b0D6LkpqLX7x1UDFEBYvQjgW8cfqYn9fD8Qn7OGj",
      #:site  => 'http://localhost:3000'
      :site => 'https://www.officedrop.com',
      :request_token_path => "/ze/oauth/request_token",
      :access_token_path => "/ze/oauth/access_token",
      :authorize_path => "/ze/oauth/authorize"
    )

    create_table :oauth_tokens do |t|
      t.integer :oauth_application_id
      t.integer :user_id
      t.string  :type, :limit => 30
      t.string  :token, :limit => 1024 # This has to be huge because of Yahoo's excessively large tokens
      t.string  :edam_shard
      t.string  :authorize_url
      t.string  :secret
      t.string  :verifier
      t.timestamps
    end
    
    add_index :oauth_tokens, :user_id

    create_table :users do |t|
      t.integer :officedrop_id
      t.integer :access_token_id
      t.integer :request_token_id
      t.timestamps
    end

  end

  def self.down
    drop_table :oauth_applications
    drop_table :oauth_tokens
    drop_table :users
  end

end