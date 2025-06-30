class UserMailer < ApplicationMailer
   default from: 'mtbcand.mtbc@gmail.com'
   
   def reset_password_email(user)
    @user = user
    @token = user.reset_password_token

    mail(to: @user.email, subject: 'Reset your password')
  end
end
