require 'rails_helper'

RSpec.describe Holding, type: :model do
    let(:user) { create(:user, :approved)}

    describe 'user association' do
        it 'requires a user' do
          holding = build(:holding, user: nil)
          expect(holding).not_to be_valid
        end
    end

    describe 'holding params validations' do
        it 'is valid with all required attributes' do
            holding = build(:holding)
            expect(holding).to be_valid
        end
    end

    describe 'symbol validation' do
        it 'requires a symbol' do
            holding = build(:holding, symbol: nil)
            expect(holding).not_to be_valid
        end
    end

    describe 'quantity validation' do
        it 'requires a quantity' do
            holding = build(:holding, quantity: nil)
            expect(holding).not_to be_valid
        end

        it 'requires quantity to be greater than 0' do
            holding = build(:holding, quantity: 0)
            expect(holding).not_to be_valid
        end

        it 'requires quantity to be an integer' do
            holding = build(:holding, quantity: 1.1)
            expect(holding).not_to be_valid
        end
    end

    describe 'buy_price validation' do
        it 'requires a buy price'do
            holding = build(:holding, buy_price: nil)
            expect(holding).not_to be_valid
        end
        it 'requires buy_price to be greater than 0' do
            holding = build(:holding, buy_price: 0)
            expect(holding).not_to be_valid
        end
        it 'accepts decimal values for buy_price' do
            holding = build(:holding, buy_price: 150.75)
            expect(holding).to be_valid
        end
    end
end