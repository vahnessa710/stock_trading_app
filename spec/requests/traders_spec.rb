require 'rails_helper'

RSpec.describe TradersController, type: :request do
  let(:trader) { create(:user, :approved) }
  let(:admin) { create(:specific_admin) }

  describe "authentication" do
    context "when user is a trader" do
      before { sign_in trader }

      it "allows access and returns 200" do
        get holdings_path
        expect(response).to have_http_status(200)
      end
    end

    context "when user is an admin" do
      before { sign_in admin }

      it "blocks access and redirects" do
        get holdings_path
        expect(response).to redirect_to(new_user_session_path)
        expect(response).to have_http_status(302) # Redirect status
      end
    end
  end
end