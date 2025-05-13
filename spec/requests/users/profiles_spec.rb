# spec/requests/users/profiles_spec.rb
require 'rails_helper'

RSpec.describe "Users::Profiles", type: :request do
    let(:trader) { create(:user, :approved)}

    before do
      sign_in trader, scope: :user
    end
  
    describe "show" do 
        it "renders users/profiles#show" do
        get users_profile_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("Account Info")
      end
    end
  end