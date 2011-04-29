# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  
  config.use_transactional_fixtures = true
  OmniAuth.config.test_mode = true
  
  OmniAuth.config.add_mock(:facebook, {
    "provider" => "facebook", "uid" => "1234", "credentials" => { "token" => "193394844038034", "secret" => "3396538a4985637f6a22906299176ff5" }, "user_info" => { "email" => "bob@nobody.com", "name" => "Bob" } 
  })
  
  OmniAuth.config.add_mock(:existing_facebook, {
    "provider" => "facebook", "uid" => "12345", "credentials" => { "token" => "193394844038034", "secret" => "3396538a4985637f6a22906299176ff5" }, "user_info" => { "email" => "fred1.flinstone@gmail.com", "name" => "Fred Flinstone" } 
  })
  
  OmniAuth.config.add_mock(:existing_login, {
    "provider" => "facebook", "uid" => "1234567", "credentials" => { "token" => "193394844038034", "secret" => "3396538a4985637f6a22906299176ff5" }, "user_info" => { "email" => "wilma.flinstone@gmail.com", "name" => "Wilma Flinstone" } 
  })
  
  OmniAuth.config.add_mock(:twitter, { 
    :provider => "twitter", :user_info => {:name => "Joe Smith", :nickname => 'joesmith'}, :uid => '123456790' 
  })
  
  OmniAuth.config.add_mock(:fb_without_twitter, {
    :provider => "twitter", :user_info => {:name => "Baby Flinstone", :nickname => 'baby'}, :uid => '765489' 
  })
    
  OmniAuth.config.add_mock(:existing_twitter, {
    :provider => "twitter", :user_info => {:name => "Fred Flinstone", :nickname => 'fred'}, :uid => '123456' 
  })
  
  def test_sign_in(user)
      controller.sign_in(user)
  end 
end
