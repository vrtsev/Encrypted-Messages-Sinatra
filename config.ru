require ::File.expand_path('../config/environment', __FILE__)
require_relative 'app_setup'
run Sinatra::Application
