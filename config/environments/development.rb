# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# 127.0.0.1:3000
#GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRTX2XchcwgyHzp4Xo0DHRAzt2aLjhSJV4d-RJg9_TnCVJIbUnmufFmwKQ"

# 127.0.0.1
#GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRRi_j0U6kJrkFvY4-OX2XYmEAa76BTgtTteRs_j2eg-IPM4tRlshkDZlQ"

# ot.local
GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRSrJKDPdel3j2oXFSgBY3kABr1iGBQtwPV3MXruzRVQInwTqR6CKkHYDQ"
