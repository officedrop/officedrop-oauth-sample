# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100817134132) do

  create_table "consumer_tokens", :force => true do |t|
    t.integer  "oauth_application_id"
    t.integer  "user_id"
    t.string   "type",                 :limit => 30
    t.string   "token",                :limit => 1024
    t.string   "edam_shard"
    t.string   "authorize_url"
    t.string   "secret"
    t.string   "verifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "consumer_tokens", ["user_id"], :name => "index_consumer_tokens_on_user_id"

  create_table "oauth_applications", :force => true do |t|
    t.string "name",               :null => false
    t.string "key",                :null => false
    t.string "secret",             :null => false
    t.string "site"
    t.string "scheme"
    t.string "http_method"
    t.string "request_token_path"
    t.string "access_token_path"
    t.string "authorize_path"
  end

  add_index "oauth_applications", ["name"], :name => "index_oauth_applications_on_name"

  create_table "users", :force => true do |t|
    t.integer  "officedrop_id"
    t.integer  "access_token_id"
    t.integer  "request_token_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
