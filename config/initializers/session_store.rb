# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ot2_session',
  :secret      => 'e0269430e9a2b6cd902e29bbe0d317609ca06ba269207f4ad9131ecefcf0cccc97af58392c2bf33da9e3f1103c809e1d11505e1bcbcb8c6af631851376350ddd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
