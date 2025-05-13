# spec/requests/devise/registrations_spec.rb
require 'rails_helper'

RSpec.describe "Devise Registrations", type: :request do
    let(:user_attributes) { attributes_for(:user) }

  describe "User Story 1: Create an Account and User Story 3: trader receives an email to confirm sign up" do 
    it "creates a new user" do
      expect {
        post user_registration_path, params: { user: user_attributes }
      }.to change(User, :count).by(1)
      .and change(ActionMailer::Base.deliveries, :count).by(1)
      email = ActionMailer::Base.deliveries.last
      new_user = User.find_by(email: user_attributes[:email])
      expect(email.to).to eq([user_attributes[:email]])
      expect(email.subject).to include("Confirmation instructions")
      expect(email.body).to include(new_user.confirmation_token)
    end

    it "redirects after successful registration" do
        post user_registration_path, params: { user: user_attributes }
        expect(response).to redirect_to(unauthenticated_root_path)
        expect(response).to have_http_status(303)
    end
  end
end