require 'spec_helper'

describe User do
  fixtures :all
  
  before(:each) do
    @mock_user = {
      :email => "joe@example.com",
      :encrypted_password => "",
      :password => "",
      :name => "name",
      :username => "username"
    }
  end
  
  it "should have an email address" do
    user = User.new(@mock_user.merge(:email => nil))
    user.should_not be_valid
  end
  
  it "should have a unique email address" do
    user = User.new(@mock_user.merge(:email => "fred.flintstone@gmail.com"))
    user.save
    user.should_not be_valid
  end
  
  it "should have a valid email address" do
    user = User.new(@mock_user.merge(:email => "nil"))
    user.should_not be_valid
  end
  
  it "should have a username" do
      user = User.new(@mock_user.merge(:username => nil))
      user.should_not be_valid
  end
  
  it "should have a username with atleast 'n' characters"
  
  it "should have a name" do
      user = User.new(@mock_user.merge(:name => nil))
      user.should_not be_valid
  end
  
  it "should have a name with atleast 'n' characters" do
      user = User.new(@mock_user.merge(:name => "nil"))
      user.should_not be_valid
  end
  
  it "should have an email address" do
    user = User.new(@mock_user.merge(:email => nil))
    user.should_not be_valid
  end
end
