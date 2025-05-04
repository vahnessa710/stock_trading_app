class Admin::UsersController < ApplicationController
    def index
        @pending_users = User.where(status: "pending")
        @users = User.where(role:"trader").order(created_at: :desc)
    end

    def approve_user
        @pending_user = User.find(params[:id])
        @pending_user.update!(status: "approved", confirmed_at: Time.now)
        UserMailer.approved_email(@pending_user).deliver_later
        redirect_to admin_users_path, notice: "#{@pending_user.email} has been approved. Email Sent!"
    end
    
    def show
        @user = User.find(params[:id])
    end

    def edit 
        @user = User.find(params[:id])
    end

    def update
        @user = User.find(params[:id])
        if @user.update!(user_params)
            redirect_to admin_user_path(@user), notice: 'Account Info is successfully updated.'
        else
            flash.alert = "Error in Updating Account Info."
            render :edit, status: :unprocessable_entity
        end
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params_with_defaults)
        if @user.save
            UserMailer.account_created_email(@user, "123456").deliver_later
            redirect_to admin_users_path, notice: "Trader successfully created. Login credentials emailed to #{@user.email}."
        else
            flash.alert = "Error in creating new trader."
            render :new, status: :unprocessable_entity
        end
    end

    def transactions
        @users = User.where(role:'trader')
        @transactions = Transaction.includes(:user).order(created_at: :desc)
      
        if params[:user_id].present?
          @transactions = @transactions.where(user_id: params[:user_id])
        end
      
        if params[:transaction_type].present?
          @transactions = @transactions.where(transaction_type: params[:transaction_type])
        end
      end

    private

    def set_user_id
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email)
    end

    def user_params_with_defaults
        user_params.merge(
          password: "123456",
          password_confirmation: "123456",
          role: "trader",
          status: "approved",
          confirmed_at: Time.now
        )
      end
end
  