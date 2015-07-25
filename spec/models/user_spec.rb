require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before :each do
    User.delete
  end
  describe "#rand" do
    describe "with no records" do
      it "should return nil" do
        User.rand.should be_nil
      end
    end
    describe "with one record" do
      before :each do
        @user = User.new(:username=> "mike", :first_name => "Mike", :last_name => 'Doe',:email => "mike@example.com").save
      end
      it "should return the one record" do
        User.rand.should == @user
      end
    end
    describe "with two records" do
      before :each do
        @user = User.new(:username=> "mike", :first_name => "Mike",:last_name => 'Doe', :email => "mike@example.com").save
        @another = User.new(:username=> "jane", :first_name => "Jane", :last_name => 'Doe',:email => "jane@example.com").save
      end
      it "should return one or the other" do
        [@user, @another].should include(User.rand)
      end
    end
  end
  
  describe "validations" do
   it "should require a username" do
    User.new().should_not be_valid
    User.new(:username => '', :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com").should_not be_valid
    User.new(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com").should be_valid
   end
   
   it "should require a name" do
      User.new(:username => "mike", :first_name=>"", :last_name => 'Doe',:email=>"mike@example.com").should_not be_valid
      User.new(:username => "mike", :first_name=>"Mike",:last_name => 'Doe', :email=>"mike@example.com").should be_valid      
   end   
   
   it "should require an email" do
       User.new(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"").should_not be_valid
       User.new(:username => "mike", :first_name=>"Mike", :last_name => 'Doe',:email=>"mike@example.com").should be_valid      
    end
   
  end
end