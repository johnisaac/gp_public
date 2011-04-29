class RegistrationsController < Devise::RegistrationsController
  
  def create
      super
      session[:omniauth] = nil unless @user.new_record?
  end
  
  def destroy
    resource.destroy 
    set_flash_message :notice, :destroyed
    sign_out_and_redirect(self.resource)
  end
    
private
  def build_resource(*args)
    super
    if session[:omniauth]
      @user.apply_omniauth(session[:omniauth])
      @user.valid?
    end
  end
end

