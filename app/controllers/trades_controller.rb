class TradesController < ApplicationController
  before_action :set_sell_data, only: [:new_sell, :create_sell, :fetch_sell_price]
  before_action :set_buy_data, only: [:new_buy, :fetch_buy_price]

  def new_buy
  end

  def create_buy
    @holding = current_user.holdings.build(holding_params)
    @balance = current_user.balance
    if @holding.buy_price.present? && @holding.quantity.present?
      total_cost = @holding.quantity * @holding.buy_price
      
      if current_user.balance >= total_cost && @holding.save
        current_user.decrement!(:balance, total_cost)
        Transaction.create!(
          user: current_user,
          symbol: @holding.symbol,
          quantity: @holding.quantity,
          amount: @holding.buy_price,
          transaction_type: "buy"
        )
        redirect_to holdings_path, notice: "Bought #{@holding.quantity} of #{@holding.symbol} shares."
      else
        flash.alert = "Insufficient balance or invalid input."
        render :new_buy, status: :unprocessable_entity
      end
    else
        flash.alert = "Please provide valid quantity and price."
        render :new_buy, status: :unprocessable_entity
      end
  end

  def new_sell
    if @set_holding.nil?
      redirect_to holdings_path, alert: "Holding not found for the selected symbol."
    end
  end

  def create_sell
    sell_quantity = params[:quantity].to_i
    sell_price = params[:sell_price].to_d
    actual_holdings = current_user.holdings.actual_holdings_for(@symbol)
    total_quantity_available = actual_holdings.sum(&:quantity)
  
    if @set_holding && total_quantity_available >= sell_quantity && sell_price > 0
      quantity_left_to_sell = sell_quantity
  
      actual_holdings.each do |holding|
        break if quantity_left_to_sell <= 0
        sell_from = [holding.quantity, quantity_left_to_sell].min
        holding.decrement!(:quantity, sell_from)
        holding.destroy if holding.quantity.zero?
        quantity_left_to_sell -= sell_from
      end

      current_user.increment!(:balance, sell_price * sell_quantity)
      Transaction.create!(
        user: current_user,
        symbol: @symbol,
        quantity: sell_quantity,
        amount: sell_price,
        transaction_type: "sell"
      )
      redirect_to holdings_path, notice: "Sold #{sell_quantity} shares of #{@symbol}"
    else
      flash.alert = "Invalid sell request."
      render :new_sell, status: :unprocessable_entity
    end
  end
  
  def fetch_buy_price
    @symbol = params[:symbol].upcase
    response = AlphaApi.fetch_records(@symbol)
      if response["Time Series (Daily)"]
        @stock_price = response.dig("Time Series (Daily)").values.first.dig("1. open")
        render :new_buy
      else
      flash.alert = "Buy Price not found"
      render :new_buy, status: :unprocessable_entity
      end
  end

  def fetch_sell_price
    response = AlphaApi.fetch_records(@symbol)

    if response["Time Series (Daily)"]
      @stock_price = response.dig("Time Series (Daily)").values.first.dig("4. close")
      render :new_sell
    else
      flash.alert = "Sell Price not found"
      render :new_sell, status: :unprocessable_entity
    end
  end

  private

  def holding_params
    params.require(:holding).permit(:symbol, :quantity, :buy_price)
  end

  def set_sell_data
    @symbol = params[:symbol]
    @holdings = current_user.holdings.owned.consolidated_by_symbol
    @set_holding = @holdings.find { |h| h.symbol == @symbol }
  end

  def set_buy_data
    @holding = Holding.new
    @balance = current_user.balance
  end 
end
