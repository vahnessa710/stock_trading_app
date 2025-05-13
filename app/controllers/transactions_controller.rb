class TransactionsController < TradersController
    def index
        @deposit_transactions = current_user.transactions.deposits.recent_first
        @stock_transactions = current_user.transactions.stock_trades.recent_first
    end
end
