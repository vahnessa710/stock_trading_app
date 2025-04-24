class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_create :set_defaults

  def trader?
    role == 'trader'
  end

  def admin?
    role == 'admin'
  end

  private

  def set_defaults
    self.role ||= 'trader'
    self.status ||= 'pending'
  end
end
