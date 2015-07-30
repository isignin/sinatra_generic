module MyApp
  class Admin < Sinatra::Base
    register Padrino::Mailer
    register Padrino::Helpers
    register Padrino::Admin::AccessControl
    
    set :admin_model, 'Account'
    set :login_page, '/session/new'
    
    enable :sessions
    disable :store_location
    
    error(403) { @title = "Error 403"; render('errors/403', :layout => :error)}
    error(404) { @title = "Error 404"; render('errors/404', :layout => :error)}
    error(500) { @title = "Error 500"; render('errors/500', :layout => :error) }    
  end
end
    