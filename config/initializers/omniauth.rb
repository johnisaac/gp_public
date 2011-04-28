
Rails.application.config.middleware.use OmniAuth::Builder do  
  provider :twitter, APP_CONFIG[:twitter][:consumer_key], APP_CONFIG[:twitter][:consumer_secret]
  Twitter.configure do |config|
    config.consumer_key = APP_CONFIG[:twitter][:consumer_key]
    config.consumer_secret = APP_CONFIG[:twitter][:consumer_secret]
    config.oauth_token = APP_CONFIG[:twitter][:oauth_token]
    config.oauth_token_secret = APP_CONFIG[:twitter][:oauth_token_secret]
  end
  provider :facebook, APP_CONFIG[:facebook][:app_id], APP_CONFIG[:facebook][:app_secret], 
                                           {:scope => 'publish_stream,offline_access,email'}
 
 end


  