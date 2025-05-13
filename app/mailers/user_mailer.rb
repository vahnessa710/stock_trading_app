class UserMailer < ApplicationMailer
  default from: 'rubyexchange@gmail.com'

  def approved_email(user)
    return unless user && user.email.present?
    @user = user
    mail(to: @user.email, subject: 'Your account has been approved!')
  end

  def account_created_email(user, plain_password)
    @user = user
    @plain_password = plain_password
    mail(to: @user.email, subject: 'You are pre-selected to trade on RubyExchange!')
  end
  
end
