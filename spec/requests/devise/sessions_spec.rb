# spec/requests/devise/sessions_spec.rb
require 'rails_helper'

RSpec.describe "User Login", type: :request do
  let!(:user) { create(:user, :approved) } 
  let!(:pending_user) { create(:user, email: 'user2@example.com') }
  
  describe "POST /users/sign_in" do
    context "with valid credentials" do
      it "User Story #2: logs in the user" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password 
          }
        }
        expect(response).to redirect_to(authenticated_root_path)
      end

      it "sets the current user" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        expect(controller.current_user).to eq(user)
      end

      it "returns success status" do
        post user_session_path, params: {
          user: {
            email: user.email,
            password: user.password
          }
        }
        follow_redirect!
        expect(response).to have_http_status(:ok)
      end
    end
  end

    context "with invalid credentials" do
        it "rejects invalid password" do
            post user_session_path, params: {
            user: {
                email: user.email,
                password: 'wrongpassword'
            } }
            expect(response.body).to include('Invalid Email or password')
        end

        it "rejects pending user" do
            post user_session_path, params: {
                user: {
                    email: pending_user.email,
                    password: pending_user.password
                }
            }
            follow_redirect!
            expect(response.body).to include('Your account is not activated yet.')
            end
    end

    describe "DELETE /users/sign_out" do
        before { sign_in user } 

        it "logs out the user" do
        delete destroy_user_session_path
        expect(response).to redirect_to(unauthenticated_root_path)
        expect(controller.current_user).to be_nil
        end
    end
end