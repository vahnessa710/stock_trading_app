class HoldingsController < TradersController
    before_action :set_balance, only: %i[index new create]

    def index
        @holdings = current_user.holdings.owned.consolidated_by_symbol
        @total_value = @holdings.sum(&:total_value)
        @fiat_pnl = calculate_fiat_pnl
    end

    def new; end

    def create
        amount = params[:balance].to_d
        if amount <= 0
            flash.now[:alert] = "Deposit amount must be greater than 0."
            render :new, status: :unprocessable_entity and return
        end
        deposit_funds!(amount)
        redirect_to holdings_path, notice: success_message(amount)
    end

    private

    def set_balance
        @balance = current_user.balance
    end

    def calculate_fiat_pnl
        buys  = current_user.transactions.where(transaction_type: "buy").sum("amount * quantity")
        sells = current_user.transactions.where(transaction_type: "sell").sum("amount * quantity")
        sells - buys
    end

    def deposit_funds!(amount)
        ActiveRecord::Base.transaction do
          current_user.increment!(:balance, amount)
          current_user.transactions.create!(
            amount: amount,
            transaction_type: "deposit",
            payment_method: params[:payment_method]
          )
        end
    end

    def success_message(amount)
        "Successfully deposited #{ActionController::Base.helpers.number_with_precision(amount, precision: 2, delimiter: ',')} USD "
    end
end
