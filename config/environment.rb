# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!

stripe_env_vars = File.join(Rails.root, 'config', 'stripe_keys.yml')
YAML.load(stripe_env_vars) if File.exists?(stripe_env_vars)
