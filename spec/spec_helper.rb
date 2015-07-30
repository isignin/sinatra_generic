# spec/spec_helper.rb
require File.join(File.dirname(__FILE__), '..', 'app.rb')
 
require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure { |c| c.include RSpecMixin }
 
# set test environment
# set :environment, :test
# set :run, false
# set :raise_errors, true
# set :logging, false
