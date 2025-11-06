class UserMailer < ApplicationMailer
  default from: 'sukhdev@collegeevents.com'  # you can change this

  def verification_email(user)
    @user = user
    @url  = verify_url(token: @user.verification_token)
    mail(to: @user.email, subject: 'Verify your email for College Events')
  end
end
