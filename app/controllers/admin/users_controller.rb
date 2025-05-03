class Admin::UsersController < ApplicationController
    def index
        @pending_users = User.where(status: "pending")
        @users = User.where(role:"trader")
    end

    def approve_user
        @pending_user = User.find(params[:id])
        @pending_user.update!(status: "approved", confirmed_at: Time.now)
        UserMailer.approved_email(@pending_user).deliver_later
        redirect_to admin_users_path, notice: "#{@pending_user.email} has been approved. Email Sent!"
    end
    
    def show
    end

    private

    def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :status)
    end
end
  