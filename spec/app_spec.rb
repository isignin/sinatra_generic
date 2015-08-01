require File.dirname(__FILE__) + '/spec_helper'
 
describe "App" do
  
  def app
      @app ||= MyApp::App
  end
     
end