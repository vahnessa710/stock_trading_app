class AdminUsersController < ApplicationController
    before_action :authenticate_user!
    before_action :ensure_admin
    
    def show
        @users = User.where(role: "trader")
    end
    
    private
    
    def ensure_admin
        unless current_user.admin?
        redirect_to authenticated_root_path, alert: "You don't have permission to access this page"
        end
    end
end
