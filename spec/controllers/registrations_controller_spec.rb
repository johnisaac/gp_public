require 'spec_helper'

describe RegistrationsController do
  fixtures :all
  render_views
  before :each do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
    
  describe "GET new_user_registration" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
end
