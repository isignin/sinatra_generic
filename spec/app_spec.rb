require File.dirname(__FILE__) + '/spec_helper'
 
describe "App" do
  
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
         expect(last_response).to match(/Edit User Record/)
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
     
end