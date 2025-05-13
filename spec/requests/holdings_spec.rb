require 'rails_helper'

RSpec.describe "Holdings", type: :request do
  let!(:trader) { create(:user, :approved, balance: 0) }
  let(:user) { trader }
  let!(:holding ) { create(:holding, user: user)}

  before do
    sign_in user, scope: :user
  end

  describe "Trader User Story 6. Portfolio Page to see all stocks" do
    it 'holdings#index upon user trader login' do
      get holdings_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('📊 My Portfolio')
      expect(response.body).to include('1')
      expect(response.body).to include('AAPL')
    end
  end

  describe "GET holdings/new" do
    it 'displays holdings#new' do
      get new_holding_path
      expect(response).to have_http_status(200)
    end
  end

  describe "create POST	/holdings" do
    let(:deposit_params) { attributes_for(:holding, :deposit_params) }
    it 'trader can deposit a specific amount' do
      expect {
        post holdings_path, params: deposit_params
      }.to change { user.reload.balance }.by(1000.00)
        .and change(Transaction, :count).by(1)
    end
  end

  describe "invalid deposit" do
    let(:invalid_params) { attributes_for(:holding, :deposit_params, balance:0) }
    let(:negative_params) { attributes_for(:holding, :deposit_params, balance:-1) }

    it 'trader cannot deposit 0 amount' do
      post holdings_path, params: invalid_params
      expect(response.body).to include("Deposit amount must be greater than 0.")
    end
    it 'trader cannot deposit negative amount' do
      post holdings_path, params: negative_params
      expect(response.body).to include("Deposit amount must be greater than 0.")
    end
  end
end
