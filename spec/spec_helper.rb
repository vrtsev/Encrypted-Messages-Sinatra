ENV['RACK_ENV'] = 'development'

require File.expand_path('../../config/environment', __FILE__)

require 'rack/test'
require 'rspec'
require 'capybara/rspec'

module RSpecMixin
  include Rack::Test::Methods
  def app
    Sinatra::Application
  end
end

RSpec.configure { |c| c.include RSpecMixin }
