class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  before_create :set_defaults
  has_many :holdings, dependent: :destroy
  has_many :transactions, dependent: :destroy
  validates :first_name, presence: true, length: { minimum: 2 }, format: { with: /\A[a-zA-Z]+(?: [a-zA-Z]+)*\z/, message: "only allows letters and spaces" }
  validates :last_name, presence: true, length: { minimum: 2 }, format: { with: /\A[a-zA-Z]+(?: [a-zA-Z]+)*\z/, message: "only allows letters and spaces" }
  validates :phone, presence: true, format: { with: /\A\+?\d{10,15}\z/, message: "must be a valid phone number (10–15 digits)" }
  validates :location, presence: true, length: { minimum: 5 }

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
