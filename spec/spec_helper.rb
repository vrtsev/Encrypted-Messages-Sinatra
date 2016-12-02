ENV['RACK_ENV'] = 'development'
require File.expand_path('../../config/environment', __FILE__)
require 'rack/test'
require 'rspec'
require 'capybara/rspec'
require 'factory_girl'
require 'simplecov'
SimpleCov.start

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure do |config|
  config.include RSpecMixin 
  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) do
    FactoryGirl.find_definitions
  end
end
