require 'rails_helper'

RSpec.describe User, type: :model do
    let(:user) { build(:user) }
    
    describe 'validations' do
        it 'is valid with all required attributes' do
            expect(user).to be_valid
        end
    end

    describe 'email validation' do
        it 'requires an email' do
            user = build(:user, email: nil)
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include("can't be blank")
        end

        it 'requires a unique email' do
            create(:user, email: user.email)
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include("has already been taken")
        end
    end

    describe 'first_name validation' do
        it 'requires a first_name' do
            user = build(:user, first_name: nil)
            expect(user).not_to be_valid
            expect(user.errors[:first_name]).to include("can't be blank")
        end

        it 'requires at least 2 characters' do
            user = build(:user, first_name: 'A')
            expect(user).not_to be_valid
            expect(user.errors[:first_name]).to include('is too short (minimum is 2 characters)')
        end

        it 'only allows letters and spaces' do
            user = build(:user, first_name: 'John1')
            expect(user).not_to be_valid
            expect(user.errors[:first_name]).to include('only allows letters and spaces')
        end
    end

     describe 'last_name validation' do
        it 'requires a last_name' do
            user = build(:user, last_name: nil)
            expect(user).not_to be_valid
            expect(user.errors[:last_name]).to include("can't be blank")
        end

        it 'requires at least 2 characters' do
            user = build(:user, last_name: 'B')
            expect(user).not_to be_valid
            expect(user.errors[:last_name]).to include('is too short (minimum is 2 characters)')
          end
     end
    
    describe 'phone validation' do
        it 'requires a phone number' do
            user = build(:user, phone: nil)
            expect(user).not_to be_valid
            expect(user.errors[:phone]).to include("can't be blank")
        end

        it 'rejects invalid phone formats' do
            user = build(:user, phone: '123')
            expect(user).not_to be_valid
            expect(user.errors[:phone]).to include('must be a valid phone number (10–15 digits)')
        end
    end

    describe 'location validation' do
        it 'requires a location' do
            user = build(:user, location: nil)
            expect(user).not_to be_valid
            expect(user.errors[:location]).to include("can't be blank")
        end
        it 'requires at least 5 characters' do
            user = build(:user, location: 'NY')
            expect(user).not_to be_valid
            expect(user.errors[:location]).to include('is too short (minimum is 5 characters)')
        end
    end
end