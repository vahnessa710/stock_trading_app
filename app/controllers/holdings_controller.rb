class HoldingsController < ApplicationController
    def index
        response = AlphaApi.fetch_records
        @symbol = response["Meta Data"]["2. Symbol"]
        @stock_price = response.dig("Time Series (Daily)").values.first.dig("1. open")
      end
end
