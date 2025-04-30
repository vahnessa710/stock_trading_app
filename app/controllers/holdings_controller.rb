class HoldingsController < ApplicationController
    def index
        @balance = current_user.balance
        @holdings = current_user.holdings.owned.consolidated_by_symbol
    end

    def new #deposit
        @balance = current_user.balance
    end

    def create #deposit
        amount = params[:balance].to_d
        if amount.positive?
            current_user.increment!(:balance, amount)
            redirect_to holdings_path, notice: "Successfully deposited PHP#{amount}"
        else
          flash.alert = "Invalid Deposit Amount."
          render :deposit, status: :unprocessable_entity
        end
    end

    private
    
    def holding_params
        params.require(:holding).permit(:symbol, :quantity, :buy_price)
    end
end
