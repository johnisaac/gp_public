class PostsController < ApplicationController
  
  before_filter :authenticate_user!, :only => [:create, :edit, :update, :destroy]
  before_filter :authorized_user, :only => [:destroy, :edit, :update]
  
  def create
    @user = current_user
    @post  = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_path
    else
       @feed_items = current_user.feed.paginate(:per_page => "10", :page => params[:page])
      render 'pages/home'
    end
  end
  
  def index
    @posts = Post.paginate(:page => params[:page])
  end
  
  def show
    @post = Post.find(params[:id])
  end
    
  def destroy
    @post.destroy
    redirect_to root_path
  end
  
private
  def authorized_user
    @post = Post.find(params[:id])
    redirect_to root_path unless current_user?(@post.user)
  end
end