module UsersHelper
  
  #user avatar helper
  def avatar_for(user)
    image_tag(user.avatar_url(:avatartiny).to_s)
  end

end
