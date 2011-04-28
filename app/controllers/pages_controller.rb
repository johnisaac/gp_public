class PagesController < ApplicationController
  
  def home
    @title = "Home"
    if user_signed_in?
      @user = current_user
      @post = Post.new
      @feed_items = current_user.feed.paginate(:per_page => "10", :page => params[:page])
    else
     #render :layout => 'special_layout' 
    end
  end

  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

  def help
    @title = "Help"
  end
  
  def blog
    @title = "Blog"
  end

end
