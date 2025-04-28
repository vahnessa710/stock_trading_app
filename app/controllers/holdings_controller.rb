class HoldingsController < ApplicationController
    def index
        # response = AlphaApi.fetch_records
        # @symbol = response["Meta Data"]["2. Symbol"]
        # @stock_price = response.dig("Time Series (Daily)").values.first.dig("1. open")
    end

    def show
    end

    def deposit
        @initial_balance = current_user.initial_balance
        amount = params[:initial_balance].to_d
        if amount.positive?
            current_user.increment!(:initial_balance, amount)
            redirect_to holdings_path, notice: "Successfully deposited PHP#{amount}"
        else
          flash.alert = "Invalid Deposit Amount."
          render :new, status: :unprocessable_entity
        end
    end
end
