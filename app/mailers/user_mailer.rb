class UserMailer < ApplicationMailer
  default from: "notifications@tradeapp.com"

  def approved_email(user)
    return unless user && user.email.present?
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved!')
  end
end
