class Admin::UsersController < ApplicationController
    def index
        @users = User.where(role: "trader")
    end
    
    def approve_user
        @user = User.find(params[:id])
        @user.update(status: "approved", confirmed_at: Time.now)
        UserMailer.approved_email(@user).deliver_later
        redirect_to admin_users_path, notice: "Trader has been approved. Email Sent!"
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :status)
    end
end
  