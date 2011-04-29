require 'spec_helper'

describe AuthenticationsController do
  fixtures :all
  render_views
  
  describe "New User" do
    context "signs up with a facebook account" do
      before(:each) do
        fb_omniauth_stub(:facebook)
        post :create, :provider => "facebook"
        @user = User.find_by_email("bob@nobody.com")
      end
      
      # this is because, by default, after facebook login, application gets directed to the new user page asking
      # the user to fill up user name
      it { @user.should be_nil }
            
      it "should direct to the new user registration page" do
        response.should redirect_to new_user_registration_path
      end
    end

    context "signs up with an existing email address registered with facebook" do
      before(:each) do
        fb_omniauth_stub(:facebook)
        request.env["omniauth.auth"]["uid"] = "00001"
        post :create, :provider => "facebook"
      end
            
      it "should direct to the new user registration page" do
        response.should redirect_to new_user_registration_path
      end
    end
    
    context "signs up with a twitter account" do
       before(:each) do
          twitter_omniauth_stub(:twitter)
          post :create, :provider => "twitter"
          @user = User.find_by_email("bob@nobody.com")
        end

        # this is because, by default, after twitter login, application gets directed to the new user page asking
        # the user to fill up user name
        it { @user.should be_nil }
        
        it "should direct to the new user registration page" do
          response.should redirect_to new_user_registration_path
        end    end
    
    context "signs up with an existing email address registered with twitter" do
      before(:each) do
        twitter_omniauth_stub(:twitter)
        request.env["omniauth.auth"]["uid"] = "00001"
        post :create, :provider => "twitter"
      end
      
      it "should direct to the new user registration page" do
        response.should redirect_to new_user_registration_path
      end    
    end
    
  end
  
  describe "Existing User" do
    context "signs in through a facebook account" do
      before(:each) do
        fb_omniauth_stub(:existing_facebook)
        post :create, :provider => "facebook"
        @user = User.find_by_email("fred1.flintstone@gmail.com")      
      end
    
      it { @user.should_not be_nil }
    
      it "should have a facebook authentication record associated with the user" do
        authentication = @user.authentications.where(:provider => "facebook").first
        authentication.should_not be_nil
      end
    
      it "should not have more than one facebook authentication record" do
        authentication = @user.authentications.where(:provider => "facebook")
        authentication.count.should == 1
      end
    
      it { should be_user_signed_in }
    
      it { flash[:notice].should == "Signed in successfully" }
    
      it { response.should redirect_to root_path}
     
    end
  
    context "adds a facebook login to the account" do
      before(:each) do
        user = User.new({:username => "wilma_flintstone", :password => "", :email => "wilma.flintstone@gmail.com"})
        test_sign_in(user)
        fb_omniauth_stub(:existing_login)
        post :create, :provider => "facebook"
        @user = User.find_by_email("wilma.flintstone@gmail.com")
      end
    
      it { @user.should_not be_nil }
    
      it { @user.authentications.count == 1 }
    
      it { should be_user_signed_in }
    
      it { flash[:notice].should == "authentications successful" }
    
      it { should redirect_to authentications_url }
    end
    
    context "signs in through a twitter account" do
      before(:each) do
        user = User.new({:username => "wilma_flintstone", :password => "", :email => "wilma.flintstone@gmail.com"})
        test_sign_in(user)
        twitter_omniauth_stub(:existing_login)
        post :create, :provider => "provider"
        @user = User.find_by_email("wilma.flintstone@gmail.com")
      end
    
      it { @user.should_not be_nil }
    
      it { @user.authentications.count == 1 }
    
      it { should be_user_signed_in }
    
      it { flash[:notice].should == "authentications successful" }
    
      it { should redirect_to authentications_url }
    end
  
    context "adds a twitter login to the account" do
      before(:each) do
        twitter_omniauth_stub(:existing_twitter)
        post :create, :provider => "twitter"
        @user = User.find_by_email("fred1.flintstone@gmail.com")      
      end
    
      it { @user.should_not be_nil }
    
      it "should have a twitter authentication record associated with the user" do
        authentication = @user.authentications.where(:provider => "twitter").first
        authentication.should_not be_nil
      end
    
      it "should not have more than one twitter authentication record" do
        authentication = @user.authentications.where(:provider => "twitter")
        authentication.count.should == 1
      end
    
      it { should be_user_signed_in }
      
      it { flash[:notice].should == "Signed in successfully" }
    
      it { response.should redirect_to root_path}
    end
  end
  
  describe "routing" do
    it "routes /auth/:twitter/callback with twitter as the provider name" do
      { :post => "/auth/twitter/callback" }.should route_to(
        :controller => "authentications",
        :action => "create",
        :provider => "twitter")
    end
    
    it "routes /auth/:facebook/callback with facebook as the provider name" do
      { :post => "/auth/facebook/callback" }.should route_to(
        :controller => "authentications",
        :action => "create",
        :provider => "facebook")
    end
  end
  
  def fb_omniauth_stub(type)
    request.env["devise.mapping"] = Devise.mappings[:user]      
    case type
    when :existing_facebook
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:existing_facebook] 
    when :facebook
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook] 
    when :existing_login
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:existing_login] 
    end        
    request.env["omniauth.auth"]["provider"] = "facebook"
    
  end
  
  def twitter_omniauth_stub(type)
    request.env["devise.mapping"] = Devise.mappings[:user]      
    case type
    when :existing_twitter
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:existing_twitter] 
    when :twitter
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] 
    when :existing_login
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:existing_login] 
    end
    request.env["omniauth.auth"]["provider"] = "twitter"
  end
end
