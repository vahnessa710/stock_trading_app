class Holding < ApplicationRecord
  belongs_to :user
  validates :symbol, presence: true
  validates :quantity, presence: true
  scope :for_user, ->(user) { where(user_id: user.id) }
end
