#config/boot.rb

# Defines our constants
RACK_ENV = ENV['RACK_ENV'] ||= 'development'  unless defined?(RACK_ENV)
APP_ROOT = File.expand_path('../..', __FILE__) unless defined?(APP_ROOT)
ENV['PROJECT_TITLE'] = "My Project Title"

require './app'