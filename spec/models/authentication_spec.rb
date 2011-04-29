require File.dirname(__FILE__) + '/../spec_helper'

describe Authentication do
  before(:each) do
    @auth = {
      :user_id => 12,
      :provider => "facebook",
      :uid => "user_id",
      :token => "token",
      :secret => "secret"
    }
  end
  
  it "should have a numeric user_id" do
    auth = Authentication.new(@auth.merge(:user_id=>"user_id"))
    auth.should_not be_valid
  end

  it "should be valid" do
    Authentication.new.should be_valid
  end
end
