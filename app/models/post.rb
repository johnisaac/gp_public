# == Schema Information
# Schema version: 20110315001207
#
# Table name: posts
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  content         :text
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  item_name       :string(255)
#  a_name    :string(255)
#  a_twitter :string(255)
#  g_from     :string(255)
#  image           :string(255)
#

class Post < ActiveRecord::Base
  mount_uploader :image, ImageUploader
  
  after_commit :share_all

  belongs_to :user

  default_scope :order => 'posts.created_at DESC'
  
  # Return microposts from the users being followed by the given user
  ## SQL specific
  scope :from_users_followed_by, lambda { |user| followed_by(user) }
  
  attr_accessible :title, :item_name, :content, :a_name, :a_twitter, :g_from, :image

  validates :title, :presence => true, :length => { :maximum => 80 }
  #validates :item_name, :presence => true, :length => { :maximum => 80 }
  #validates :a_name, :presence => true, :length => { :maximum => 80 }
  #validates :a_twitter, :presence => true, :length => { :maximum => 16 }
  #validates :g_from, :presence => true, :length => { :maximum => 80 }
  #validates :content, :presence => true, :length => { :maximum => 500 }
  #validates :user_id, :presence => true
  #validates :image, :presence => true
  
  
  def share_all
     # checks for existing facebook auth provider
     if user.authentications.where(:provider => 'facebook').any?
        user.facebook_share(self)
     end
     # checks for existing twitter auth provider
     if user.authentications.where(:provider => 'twitter').any?
        user.twitter_share(self) 
    end
  end
  
  private
    def self.followed_by(user)
      #SQL specific
      followed_ids = %(SELECT followed_id FROM relationships
                       WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id", :user_id => user)
    end

end
