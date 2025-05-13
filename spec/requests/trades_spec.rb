require 'rails_helper'

RSpec.describe "Trades", type: :request do
    let!(:trader) { create(:user, :approved, balance: 1000) } # trader signup should be approved
    let!(:holding ) { create(:holding, user: trader)} 
    let(:buy_price) { 150.00 } 
    let(:sell_price) { 197.49 } 

    before do
        sign_in trader, scope: :user
        allow(AlphaApi).to receive(:fetch_records).and_return(
            { 
                "Time Series (Daily)" => { 
                "2023-01-01" => { 
                    "1. open" => buy_price.to_s,  # For buy operations
                    "4. close" => sell_price.to_s # For sell operations
                } 
                } 
            }
        )
    end

    describe "Trader User Story 5: buy a stock add to my investment" do 
        it "renders trades#new_buy" do
        get buy_trades_path
        expect(response).to have_http_status(200)
        end
    end

    describe "Trader User Story 5: buy a stock add to my investment #create_buy" do
        it 'trader can buy a stock' do
            expect {
                post buy_trades_path, params: { holding: attributes_for(:holding, buy_price: buy_price) }
            }.to change { trader.reload.balance }.by(-(buy_price * holding.quantity))
                .and change(Holding, :count).by(1)
                .and change(Transaction, :count).by(1)
                expect(response).to redirect_to(holdings_path)
                follow_redirect!
                expect(response.body).to include("Bought #{holding.quantity} of #{holding.symbol} shares")
        end
    end

    describe "GET /trades/sell" do 
        it "renders trades#new_sell" do
        get sell_trades_path(symbol: holding.symbol)
        expect(response).to have_http_status(200)
        end
    end

    describe "Trader User Story 8: I want to **sell my stocks** to gain money #create_sell" do
        let(:sell_quantity) { 1 }
        let(:initial_balance) { trader.balance }

        it 'trader can sell a stock' do
            expect {
            post sell_trades_path, params: {
            symbol: 'AAPL',
            quantity: sell_quantity,
            sell_price: sell_price } }.to change { trader.reload.balance }.by(sell_price * sell_quantity)
            .and change { trader.holdings.where(symbol: 'AAPL').sum(:quantity) }.by(-sell_quantity)
            .and change(Transaction, :count).by(1)
            expect(response).to have_http_status(302)
            follow_redirect!
            expect(response.body).to include("Sold #{sell_quantity} shares of AAPL")
        end
    end

    describe "fetch_buy_price" do
        it "allows trader to see check buy price" do
            get fetch_buy_price_trades_path, params: { symbol: 'AAPL' }
            expect(response).to have_http_status(200)
        end
    
        it "does not allow empty symbol, when buying and shows validation errors in flash" do
            get fetch_buy_price_trades_path, params: { symbol: nil }
            expect(response.body).to include("Invalid stock, please select from the stock options.")
        end
    end

    describe "fetch_sell_price" do
        it "allows trader to see check sell price" do
            get fetch_sell_price_trades_path, params: { symbol: 'AAPL' }
            expect(response).to have_http_status(200)
        end
        it "does not allow empty symbol, when selling and shows validation errors in flash" do
            get fetch_buy_price_trades_path, params: { symbol: nil }
            expect(response.body).to include("Invalid or missing stock symbol. Please select a valid stock.")
        end
    end
end