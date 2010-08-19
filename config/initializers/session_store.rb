# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_officedrop_oauth_sample_session',
  :secret      => 'b112afc3b3cd1c7332c6267375c843e1ccc893d304218a1cbd7a573dbf7bdbb121ae97c64bf3753c911b205b597fa1359840afebf276be3e346ad756ecc9ea2b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
