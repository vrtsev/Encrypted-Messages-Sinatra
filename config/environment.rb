ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
 
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
require 'rubygems'
require 'uri'
require 'pathname'
require 'pg'
require 'active_record'
require 'sinatra'
require 'aes'
require 'erb'
if development?
  require 'sinatra/reloader'
  require 'pry'
  # require 'logger'
end
 
# Some helper constants for path-centric logic
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))
APP_NAME = APP_ROOT.basename.to_s
 
# Set up the controllers and helpers
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', '*.rb')].each { |file| require file }
 
# Set up the database and models
require APP_ROOT.join('config', 'database')
 
configure do
  enable :sessions
  set :root, File.expand_path('.')
  set :session_secret, ENV['SESSION_SECRET'] || 'this is a secret shhhhh'
  set :views, File.join(Sinatra::Application.root, 'app', 'views')
end