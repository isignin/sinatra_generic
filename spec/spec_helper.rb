# spec/spec_helper.rb

ENV['RACK_ENV'] = 'test'
require File.join(File.dirname(__FILE__), '..', 'app.rb')
 
require 'rack/test'
require 'rspec'

module RSpecMixin
  include Rack::Test::Methods
  def app() App end
end

RSpec.configure { |c| c.include RSpecMixin }

