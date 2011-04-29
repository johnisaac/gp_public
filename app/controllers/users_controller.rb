class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:create, :show, :new]

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.paginate(:per_page => "10",:page => params[:page])
    @title = @user.name
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow' 
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end
end
