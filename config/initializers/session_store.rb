# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_videoheatmaps_session',
  :secret      => '5e4d037934ec3886651d9e502e38fa104b1f84ba37c1535e283a83eaac7452265d90d8cc281bead420695bb4b4e8663116062356ad7d395e4ac1f9dc1e89e09f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
