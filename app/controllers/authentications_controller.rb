class AuthenticationsController < ApplicationController
  
  def index
    @title = "Authentications"
    @authentications = current_user.authentications if current_user
  end

  def create
    # creates omniauth hash and looks for an previously established authentication
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    # if previous authentication found, sign in user
    if authentication
      flash[:notice] = "Signed in successfully"
      sign_in_and_redirect(:user, authentication.user)
    #  for users already signed in (current_user), create a new authentication for the user
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'], :token => (omniauth['credentials']['token'] rescue nil),
                                           :secret => (omniauth['credentials']['secret'] rescue nil))
      flash[:notice] = "authentications successful"
      redirect_to authentications_url
    # new user is created and authentications are built through apply_omniauth(omniauth)
    else
      user = User.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully"
        sign_in_and_redirect(:user, user)
      # if validations fail to save user, redirects to new user registration page 
      # new twitter authentications redirect so user can enter their password
      else
        session[:omniauth] = omniauth
        redirect_to new_user_registration_url
      end
     end
   end

  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = "Successfully destroyed authentication."
    redirect_to authentications_url
  end

end
