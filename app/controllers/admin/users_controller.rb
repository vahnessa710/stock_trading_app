class Admin::UsersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_user_id, only: %i[approve_user show edit update]
    before_action :set_traders, only: %i[index transactions]

    def index 
        @pending_users = User.where(status: "pending")
    end

    def approve_user 
        @user.update!(status: "approved")
        UserMailer.approved_email(@user).deliver_later
        redirect_to admin_users_path, notice: "#{@user.email} has been approved. Email Sent!"
    end
    
    def show; end 

    def edit; end 

    def update 
        if @user.update(user_params)
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
        password = generated_password
        @user = User.new(user_params.merge(
            password: password,
            password_confirmation: password,
            role: "trader",
            status: "approved",
            confirmed_at: Time.now
        ))
        if @user.save
            UserMailer.account_created_email(@user, password).deliver_later
            redirect_to admin_users_path, notice: "Trader successfully created. Login credentials emailed to #{@user.email}."
        else
            flash.alert = "Error in creating new trader."
            render :new, status: :unprocessable_entity
        end
    end

    def transactions #
        @transactions = Transaction.includes(:user).order(created_at: :desc)
        if params[:user_id].present?
            if @users.exists?(id: params[:user_id])
                @transactions = @transactions.where(user_id: params[:user_id])
            else
                flash.alert = "Trader ID does not exist."
                render :transactions
            end
        end
        if params[:transaction_type].present?
          @transactions = @transactions.where(transaction_type: params[:transaction_type])
        end
      end

    private

    def set_user_id
        @user = User.find(params[:id])
    end

    def set_traders
        @users = User.where(role: 'trader').order(created_at: :desc)
    end

    def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :status, :location, :phone, :role)
    end

    def generated_password
        SecureRandom.alphanumeric(8)
    end
end
  