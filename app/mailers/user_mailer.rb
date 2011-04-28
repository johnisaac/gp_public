class UserMailer < ActionMailer::Base
  default :from => "drew@daycap.co"
  
  
  def reset_password_instructions(user)
     @user = user
     @url  = "http://localhost:3000"
     mail(:to => user.email,
          :subject => "recover your password"
          )
   end
end
