require 'rails_helper'

RSpec.describe Transaction, type: :model do
    it 'is valid with a user' do
        user = create(:user)
        transaction = build(:transaction, user: user)
        expect(transaction).to be_valid
    end

    it 'is invalid with a user' do
        user = create(:user)
        transaction = build(:transaction, user: nil)
        expect(transaction).not_to be_valid
    end
end