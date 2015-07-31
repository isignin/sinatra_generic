# spec/spec_helper.rb

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__
 
require 'rack/test'
require 'rspec'
require 'faker'

module RSpecMixin
  include Rack::Test::Methods
  def app() described_class end
end

RSpec.configure do |config|
  config.include RSpecMixin 
  config.backtrace_exclusion_patterns = []
end
