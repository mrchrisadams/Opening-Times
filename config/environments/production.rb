# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!
config.gem "newrelic_rpm"
  
# 127.0.0.1
# GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRRi_j0U6kJrkFvY4-OX2XYmEAa76BTgtTteRs_j2eg-IPM4tRlshkDZlQ"

# beta.opening-times.co.uk
#GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRS2nt5tQfrsCRvkZWYugf3hlgQzEhSia2kJSzm0PVghPyNJasj3zSMFMw"

GOOGLE_MAPS_API_KEY = "ABQIAAAAztgMQ8gk3qQo-szAq24XnRR0L2lY_JtzxLQOiPPwPJmr0n1RhxQM1pLtcCcdbyhal4ob1jvbY-2dzg"

RECAPTCHA_PUBLIC_KEY = ""
RECAPTCHA_PRIVATE_KEY = ""

