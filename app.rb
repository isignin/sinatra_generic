require 'rubygems'

# Setup load paths
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

# Require base
require 'sinatra/base'
require 'sinatra/contrib'
require "sinatra/reloader"
require "sinatra/flash"
require 'sinatra/partial'
require 'sequel'
require 'active_support'
require 'active_support/core_ext'
require 'active_support/json'
require "digest/sha1"
require 'rack/standards'
require 'pony'
require 'rake'
require 'logger'

Dir['lib/**/*.rb'].sort.each { |file| require file }

require 'config/database'
require 'app/extensions'
require 'app/models'
require 'app/helpers'
require 'app/routes'

module MyApp
  class App < Sinatra::Base
    
    register Sinatra::Contrib
    register Sinatra::Flash
    
    configure do
      register Sinatra::Partial

      disable :static
      enable :session, :logging
      
      file = File.new("#{settings.root}/log/#{settings.environment}.log", 'a+')
      file.sync = true

      use Rack::CommonLogger, file
      
      set :method_override, true
      
      set :sessions,
          :httponly     => true,
          :secure       => production?,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET']
      
    end
    
     use Rack::Deflater
     use Rack::Standards
     
    # Other routes:
    use Routes::Apps
    use Routes::Static
    use Routes::Users    
    
    unless settings.production?
      use Routes::Assets
    end
  end
end

include MyApp::Models