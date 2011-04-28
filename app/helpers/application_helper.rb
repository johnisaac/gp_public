module ApplicationHelper
  
  
  #title helper return title on per-page basis
  def title
    base_title = "Under Construction App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  
  #logo helper
  def logo
    image_tag("logo.png", :alt =>  "Under Contruction Logo", :class =>"round")
  end


  #current_user? helper
  def current_user?(user)
    user == current_user
  end

end
