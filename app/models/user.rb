class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  before_create :set_defaults
  has_many :holdings, dependent: :destroy
  has_many :transactions, dependent: :destroy
  
  def admin?
    role == "admin"
  end

  def trader?
    role == "trader"
  end

  def approved?
    status == "approved"
  end

  def pending?
    status == "pending"
  end

  private

  def set_defaults
    self.role ||= 'trader'
    self.status ||= 'pending'
  end
end
