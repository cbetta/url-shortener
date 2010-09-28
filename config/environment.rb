# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Urlshortner::Application.initialize!

# config.gem 'memcached-northscale', :lib => 'memcached'
# require 'memcached'

ROOT_URL = 'http://example.com'
SECRET = 'abc123' # change this to your own secret