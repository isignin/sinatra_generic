require File.dirname(__FILE__) + '/../spec_helper'
 
describe "Routes/Users" do
  
  def app
      @app ||= MyApp::App
  end
    
  it "should respond to /" do
    get '/'
    expect(last_response).to be_ok
  end
  
  describe "get /users" do
    it "should show a list of users" do
      User.create(:username => 'adam', :first_name => 'Adam', :last_name => 'Doe',:email => 'adam@example.com', :password=>'pass', :password_confirmation =>'pass')
      User.create(:username => 'eve', :first_name => 'Eve', :last_name => 'Doe',:email => 'eve@example.com', :password=>'pass', :password_confirmation =>'pass')
      get '/users'
      expect(last_response).to be_ok
      expect(last_response.body).to include("adam")
      expect(last_response.body).to include("eve")
    end  
  end 
  
  describe "get /users/new" do
      it "should have a form" do
        get '/users/new'
        expect(last_response).to be_ok
        expect(last_response).to match /role="form" action="\/users" method="post">/
      end
  end
  
  describe "post /users" do
      it "should create a new user" do
        DB.run "delete from 'users'"
        post '/users', {:user=>{:username => 'jane', :first_name => 'Jane', :last_name => 'Doe', :email=>'jane@example.com', :password=>'pass', :password_confirmation=>'pass'}}

        expect(User.count).to eq(1)

        expect(last_response).to be_ok
        expect(last_response).to match("Record posted")
      end
  end
  
  describe "get /users/:id" do
      it 'should show the user' do
        user = User.create(:username => 'mike', :first_name => 'Mike', :last_name => 'Doe',:email => 'mike@example.com', :password=>'pass', :password_confirmation =>'pass')
        get "/users/#{user.id}"

        expect(last_response).to be_ok
        expect(last_response.body).to include('mike')
      end
  end
  
  describe "get /users/:id/edit" do
      before :each do
        @user = User.create(:username => "mike", :first_name => Faker::Name.first_name,:last_name => Faker::Name.last_name, :email => Faker::Internet.email, :password=>'pass', :password_confirmation =>'pass')
        get "/users/#{@user.id}/edit"
      end

      it "should render an edit form" do
         expect(last_response).to be_ok
         expect(last_response).to match(/Edit User Profile/)
         expect(last_response).to match /role="form" action="\/users/#{@user.id}" method="post">/
      end
  end
  
  describe "put /users/:id" do      
      it "should update the record" do
        user = User.create(:username => 'Mike', :first_name => 'Mike',:last_name => 'Doe', :email => Faker::Internet.email, :password=>'pass', :password_confirmation =>'pass')
        put "/users/#{user.id}", {:user => {:username => 'mike'}} 
        
        expect(user.reload.username).to eq('mike')
        expect(last_response).to be_ok
        expect(last_response.body).to match("User Profile")
      end
  end
  
  describe "delete /users/:id" do
      it "should delete the record" do
        DB.run "delete from 'users'"
        user = User.create(:username => 'mike', :first_name => 'Mike', :last_name => 'Doe', :email => Faker::Internet.email, :password=>'pass', :password_confirmation =>'pass')
        delete "/users/#{user.id}"
        expect(last_response).to be_ok
        expect(User.count).to eq(0)
        expect(last_response.body).to match /Record delete successfully/  
      end
  end
  
  describe '/login' do
    before :each do
      DB.run "delete from 'users'"
      @user = User.create(:username => 'john', :first_name => 'John', :last_name => 'Doe', :email => Faker::Internet.email, :password=>'pass', :password_confirmation =>'pass', :verified => true)
    end
    
    it "should show the login screen" do
      get "/login"
      expect(last_response).to be_ok
      expect(last_response.body).to match /<form action="\/login" method="post">/
    end
    
    it "should fail if user unknown" do
      post "/login", :username => "jane", :password=>"wrong"
      expect(last_response.body).to match /Sorry. I don&#39;t know you/
      expect(last_response.body).to match /<form action="\/login" method="post">/
    end
    
    it "should fail if account not verified" do
      @user.update(:verified => false)
      post "/login", :username => "john", :password=>"pass"
      expect(last_response.body).to match /Your Email address has not been verified/
      expect(last_response.body).to match /<form action="\/login" method="post">/
    end
    
    it "should fail if incorrect password" do
      post "/login", :username => "john", :password=>"wrong"
      expect(last_response.body).to match /Incorrect password/
      expect(last_response.body).to match /<form action="\/login" method="post">/
    end 
    
    it "should succeed if user exist, password is correct and account is verified" do
      post "/login", :username => "john", :password=>"pass"
      expect(last_response.body).to match /User is verified. You are ok/
    end       
  end
  
  describe "user signup" do
    before :each do
      DB.run "delete from 'users'"
    end
    
    it "should show the signup screen" do
      get "/sign_up"
      expect(last_response).to be_ok
      expect(last_response.body).to match /<form action="\/sign_up" method="post">/
    end
    
    it "should fail if password does not match password confirmation" do
      post "/sign_up", {:user => {:username => 'jane', :first_name => 'Jane', :last_name => 'Doe', :email => 'jane@example.com', :password=>'pass', :password_confirmation =>'password'}}
      expect(last_response.body).to match /Your passwords do not match/
      expect(last_response.body).to match /<form action="\/sign_up" method="post">/  
    end
    
    it "should fail if user name is already registered" do
        @user = User.create(:username => 'john', :first_name => 'John', :last_name => 'Doe', :email => 'john@example.com', :password=>'pass', :password_confirmation =>'pass')
        post "/sign_up", {:user => {:username => 'john', :first_name => 'John', :last_name => 'Doe', :email => 'john@example.com', :password=>'pass', :password_confirmation =>'pass'}}
        expect(last_response.body).to match /Username is already taken/
    end
    
    describe "Send out email after successful sign up" do
      it "is a pending test"
    end 
    
  end    
  
  describe "Reset Password" do
    
    before :each do
      DB.run "delete from 'users'"
      @user = User.create(:username => 'john', :first_name => 'John', :last_name => 'Doe', :email => 'john@example.com', :password=>'pass', :password_confirmation =>'pass')
    end
    
    it "should show the password reset request screen" do
      get "/reset_password"
      expect(last_response).to be_ok
      expect(last_response.body).to match /<form action="\/reset_password" method="post">/
    end
    
    it "should send verification email upon password reset request" do
      post "/reset_password", :username => "john"
      expect(last_response).to be_ok
      expect(last_response.body).to match /Password reset email sent/
      expect(@user.reload.token).not_to be_empty
    end
    
    describe "Send out email after successful password reset request" do
      it "is a pending test"
    end
    
    it "should not send verification email for unknown username" do
      post "/reset_password", :username => "jane"
      expect(last_response).to be_ok
      expect(last_response.body).to match /Sorry. I do not know you/
      #return to password reset request page  
      expect(last_response.body).to match /<form action="\/reset_password" method="post">/
    end
    
    it "should show the password reset form" do
      @user.update(:token => "AbCdEfGhIjKlMn")
      get "/reset_password/AbCdEfGhIjKlMn"
      expect(last_response).to be_ok
      expect(last_response.body).to match /<form action="\/reset_pass" method="post">/
    end
    
    it "should not show the password reset form if invalid token" do
      @user.update(:token => "AbCdEfGhIjKlMn")
      get "/reset_password/CdEfGhIjKlMn"
      expect(last_response).to be_ok
      expect(last_response.body).to match /Token invalid. Please contact your administrator/
    end
    
    it "should reset password if password matches confirmation password" do
      post '/reset_pass', :id => @user.id, :password =>"pass", :password_confirmation => "pass"
      expect(last_response).to be_ok
      expect(last_response.body).to match /Password has been reset/
    end 
    
    it "should not reset password if password does not matches confirmation password" do
      post '/reset_pass', {:id => @user.id, :password =>"pass", :password_confirmation => "nopass"}
      expect(last_response).to be_ok
      expect(last_response.body).to match /New Password does not match your confirmation password/
    end 
    it "should not reset password if user is unknown" do
      post '/reset_pass', {:id => 999, :password =>"pass", :password_confirmation => "pass"}
      expect(last_response).to be_ok
      expect(last_response.body).to match /Do not know you.../
    end
  end     
end