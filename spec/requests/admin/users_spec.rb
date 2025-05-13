# spec/requests/admin/users_spec.rb
require 'rails_helper'

RSpec.describe "Admin::Users", type: :request do

  let!(:admin) { create(:user, :admin) }
  let!(:trader) { create(:user) }

  before do
    sign_in admin, scope: :user 
  end

  describe "GET #index" do
    it "Admin User Story 4 and 5 - see all traders in the app and pending traders page" do
      get admin_users_path
      expect(response.body).to include(trader.email)
      expect(response.body).to include('pending')
    end
  end

  describe "PATCH #approve_user" do
    let!(:trader) { create(:specific_trader, :pending) }

      it "Admin User Story 6: approves a pending trader -- Trader User Story 4: receive an approval Trader Account email" do
        perform_enqueued_jobs do
          expect {
            patch approve_user_admin_user_path(trader)
          }.to change { ActionMailer::Base.deliveries.count }.by(1)
          expect(trader.reload.status).to eq('approved')
          expect(response).to redirect_to(admin_users_path)
          email = ActionMailer::Base.deliveries.last
          new_user = User.find_by(email: trader[:email])
          expect(email.to).to eq([trader[:email]])
          expect(email.subject).to include("Your account has been approved!")
          expect(email.body).to include(new_user.confirmation_token)
        end
      end
    end

    describe "GET /admin/users/:id #show" do
      it "Admin User Story 3: admin can view a specific trader's details" do
        get admin_user_path(trader)
        expect(response).to have_http_status(200)
        expect(response.body).to include('Account Info')
        expect(response.body).to include('Pending')
       end
    end

    describe "GET /admin/users/:id(.:format) #edit" do
      it "Admin User Story 2: render edit view for editing specific trader details " do
        get edit_admin_user_path(trader)
        expect(response).to have_http_status(200)
        expect(response.body).to include('Edit Trader Account Info')
       end
    end

    describe "/admin/users/:id/edit" do
      let(:trader) { create(:user, :approved) }
        it "Admin User Story 2: update specific trader's details" do
          patch admin_user_path(trader), params: { user: { location: "Australia"  } }
          expect(response).to redirect_to(admin_user_path(trader))
          expect(trader.reload.location).to eq("Australia")
      end
    end

    describe "GET /admin/users/new" do
      it "Admin User Story 1: render new view to create a new trader" do
        get new_admin_user_path
        expect(response).to have_http_status(200)
        expect(response.body).to include('Create Trader Account')
        expect(response.body).to include('Create New Trader')
       end
    end

  describe "POST create" do
    it "Admin User Story 1: admin manually adds a trader in the app" do   
      perform_enqueued_jobs do
        expect {
          post admin_users_path, params: { user: attributes_for(:user, email: "user2@email.com") }
        }.to change(User, :count).by(1) 
         .and change { ActionMailer::Base.deliveries.size }.by(1)
      end
    end
  end

  describe "transactions" do
    it "Admin User Story 7: admin can view all transactions" do
      get transactions_admin_users_path
      expect(response).to have_http_status(200)
      expect(response.body).to include('All Users Transactions')
    end
  end
end