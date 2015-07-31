require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  
  describe "validations" do
   it "should require a username" do
    user = User.new(:username => '', :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
    expect(user.valid?).to be false
   end
   
   it "should require a first_name" do
      user = User.new(:username => "mike", :first_name=>"", :last_name => 'Doe',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
      expect(user.valid?).to be false
   end 
   
   it "should require a last_name" do
      user = User.new(:username => "mike", :first_name=>"Mike", :last_name => '',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
      expect(user.valid?).to be false
   end   
   
   it "should require an email" do
       user = User.new(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"", :password=>'pass', :password_confirmation =>'pass')
       expect(user.valid?).to be false
    end
   
    context "email already taken" do
        DB.run "delete from 'users'"
        user = User.create(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
        user2 = User.create(:username => "Sam", :first_name=>"Sam", :last_name => 'Doe',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
        it { should_not be_valid }
    end 
    
    context "username already registered" do
        DB.run "delete from 'users'"
        user = User.create(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com", :password=>'pass', :password_confirmation =>'pass')
        user2 = User.create(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"mike2@example.com", :password=>'pass', :password_confirmation =>'pass')
        it { should_not be_valid }
    end   
   
  end
end