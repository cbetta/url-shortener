# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Urlshortner::Application.initialize!

config.gem 'memcached-northscale', :lib => 'memcached'
require 'memcached'

ROOT_URL = 'http://cgbdigital.com'
SECRET = 'b573ce79af0179cde90bc6aa33e99039'