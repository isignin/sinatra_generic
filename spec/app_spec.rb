require File.dirname(__FILE__) + '/spec_helper'
 
describe "App" do
  include Rack::Test::Methods
  
  def app
      @app ||= Sinatra::Application
  end
    
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
  
  describe "get /users" do
    it "should show a list of users" do
      User.new(:username => 'adam', :first_name => 'Adam', :last_name => 'Doe',:email => 'adam@example.com').save
      User.new(:username => 'eve', :first_name => 'Eve', :last_name => 'Doe',:email => 'eve@example.com').save
      get '/users'
      last_response.should be_ok
      last_response.body.should match /adam/
      last_response.body.should match /eve/
    end  
  end 
  
  describe "get /users/new" do
      it "should have a form" do
        get '/users/new'
        last_response.should be_ok
        last_response.should match /<form action="\/users" method="post">/
      end
  end
  
  describe "post /users" do
      it "should create a new user" do
        User.delete
        post '/user', :username => 'jane'

        user = User.first
        user.should_not be_nil

        follow_redirect!

        last_request.url.should == "http://example.org/users/#{user.id}"
        last_response.should be_ok
      end
  end
  
  describe "get /users/:id" do
      it 'should show the user' do
        user = User.new(:username => 'mike', :first_name => 'Mike', :last_name => 'Doe',:email => 'mike@example.com').save
        get "/users/#{user.id}"

        last_response.should be_ok
        last_response.should match /mike/
      end
  end
  
  describe "get /users/:id/edit" do
      before :each do
        @user = User.new(:username => 'mike', :first_name => 'Mike',:last_name => 'Doe', :email => 'mike@example.com').save
        get "/user/#{@user.id}/edit"
      end

      it "should have a form" do
        last_response.should be_ok
        last_response.should match /<form action="\/users/#{@user.id}" method="post">/
      end

      it "should have the fields defaulted" do
        last_response.should be_ok
        last_response.should match /<input type="text" username="username" value="mike"\/>/
      end
  end
  
  describe "put /users/:id" do
      it "should update the record" do
        user = User.new(:username => 'mike', :first_name => 'Mike',:last_name => 'Doe', :email => 'mike@example.com').save
        put "/users/#{user.id}", :username => 'mike'
        user.reload.username.should == 'Mike'

        follow_redirect!

        last_request.url.should == "http://example.org/users/#{user.id}"
        last_response.should be_ok
      end
  end
  
  describe "delete /users/:id" do
      it "should delete the record" do
        user = User.new(:username => 'mike', :first_name => 'Mike', :last_name => 'Doe', :email => 'mike@example.com').save
        delete "/users/#{user.id}"
        lambda{user.reload}.should raise_error

        follow_redirect!

        last_request.url.should == "http://example.org/users"
        last_response.should be_ok
      end
  end
     
end