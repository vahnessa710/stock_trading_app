class HoldingsController < ApplicationController
    before_action :set_balance, only: %i[index new]
    def index
        @holdings = current_user.holdings.owned.consolidated_by_symbol
        @total_value = @holdings.sum(&:total_value)
        total_buys = current_user.transactions.where(transaction_type: "buy").sum("amount * quantity")
        total_sells = current_user.transactions.where(transaction_type: "sell").sum("amount * quantity")
        @fiat_pnl = total_sells - total_buys
    end

    def new; end

    def create
        amount = params[:balance].to_d
        if amount.positive?
            ActiveRecord::Base.transaction do 
                current_user.increment!(:balance, amount)
                Transaction.create!(
                  user: current_user,
                  amount: amount,
                  transaction_type: "deposit",
                  payment_method: params[:payment_method]
                )
              end
            redirect_to holdings_path, notice: "Successfully deposited PHP#{ActionController::Base.helpers.number_with_precision(amount, precision: 2, delimiter: ',')}"
        else
          flash.alert = "Invalid Deposit Amount."
          render :deposit, status: :unprocessable_entity
        end
    end

    private
    
    def holding_params
        params.require(:holding).permit(:symbol, :quantity, :buy_price)
    end

    def set_balance
        @balance = current_user.balance
    end
end
