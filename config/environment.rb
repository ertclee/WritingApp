# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.raise_delivery_errors = true
