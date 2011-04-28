# == Schema Information
# Schema version: 20110329025505
#
# Table name: authentications
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  provider   :string(255)
#  uid        :string(255)
#  created_at :datetime
#  updated_at :datetime
#  token      :string(255)
#  secret     :string(255)
#

class Authentication < ActiveRecord::Base
    # Not needed, these attr won't be accessed in the views
    #attr_accessible :user_id, :provider, :uid, :token, :secret
    belongs_to :user
end
