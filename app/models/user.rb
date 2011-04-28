# == Schema Information
# Schema version: 20110329025505
#
# Table name: users
#
#  id                   :integer         not null, primary key
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer         default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#  name                 :string(255)
#  username             :string(255)
#  bio                  :string(255)
#  avatar               :string(255)
#

class User < ActiveRecord::Base
  mount_uploader :avatar, ImageUploader
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  validates :username, :presence => true, :length => { :maximum => 25 }
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :avatar, :username
  
  has_many :posts,  :dependent => :destroy
  
  has_many :authentications, :dependent => :destroy
  
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  
  has_many :following, :through => :relationships, :source => :followed
  
  has_many :followers, :through => :reverse_relationships, :source => :follower
  
  
  def feed
    #SQL specific
    Post.from_users_followed_by(self)
  end
  
  
  
  # facebook token used with fb_graph gem to interact with facebook api
  def facebook
    @fb_user ||= FbGraph::User.me(self.authentications.find_by_provider('facebook').token)
  end
  # oauth_token and oauth_token_secret used with twitter gem to interact with twitter api
  def twitter
    unless @twitter_user
      provider = self.authentications.find_by_provider('twitter')
      @twitter_user = Twitter::Client.new(:oauth_token => provider.token, :oauth_token_secret => provider.secret) rescue nil
    end
    @twitter_user
  end
  
  # shares to twitter feed
  def twitter_share(post)
     url =  Rails.application.routes.url_helpers.post_url(self)
    twitter.update("New post #{Time.now.to_date.to_s}:#{post.title} #{url}")
  end
   
   # shares to facebook feed
   def facebook_share(post)
     url =  Rails.application.routes.url_helpers.post_url(self)
     facebook.feed!(
      :link => "#{url}",
      :name => "gp",
      :description => "this is a test",
      :message => "#{post.content}"
     )
   end
  
  
  
  
  
  # following and followers
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end



  # edit user profile without needinging password
  def update_with_password(params={}) 
    if params[:password].blank? 
      params.delete(:password) 
      params.delete(:password_confirmation) if params[:password_confirmation].blank? 
    end 
    update_attributes(params) 
  end
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  

 
 # from authentications controller, new user split into type of provider
 def apply_omniauth(omniauth)
   case omniauth['provider']
   when 'facebook'
     self.apply_facebook(omniauth)
   when 'twitter'
     self.apply_twitter(omniauth)
   end
   # builds authentication with provider, uid, token, and secret
   authentications.build(hash_from_omniauth(omniauth))
  end

 protected

 # sets new user attributes with name and email attributes from facebook
 def apply_facebook(omniauth)
   self.name = omniauth['user_info']['name']
   self.email = omniauth['user_info']['email'] if email.blank?
 end
 
 # sets new user attributes with the name attribute from twitter 
 def apply_twitter(omniauth)
   if (extra = omniauth['extra']['user_hash'] rescue false)
     # Example fetching extra data. Needs migration to User model:
     # self.firstname = (extra['name'] rescue '')
     self.name = (extra['name'] rescue '')
     self.bio = (extra['description'] rescue '')
     
   end

 end

 # set authentication attributes to those from 'omniauth' hash
 def hash_from_omniauth(omniauth)
   {
     :provider => omniauth['provider'],
     :uid => omniauth['uid'],
     :token => (omniauth['credentials']['token'] rescue nil),
     :secret => (omniauth['credentials']['secret'] rescue nil)
   }
 end
end
