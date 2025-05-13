RSpec.describe "Transactions", type: :request do
  let!(:trader) { create(:user, :approved, balance: 1000) } 
  let!(:holding ) { create(:holding, user: trader)}
  
  before do
    sign_in trader, scope: :user
  end

  describe "Trader User Story 7. Transaction page to sell all transactions made by buying and selling stocks" do 
      it "renders transaction#index" do
      get transactions_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('Deposit History')
      expect(response.body).to include('Buy/Sell History')
    end
  end
end