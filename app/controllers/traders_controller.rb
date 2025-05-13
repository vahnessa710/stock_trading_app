class TradersController < ApplicationController
    before_action :authenticate_trader!
  end
  class HoldingsController < TradersController
  end
  
  class TradesController < TradersController
  end

  class TransactionsController < TradersController
  end