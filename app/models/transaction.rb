class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :holding
  scope :for_user, ->(user) { where(user_id: user.id) }
end
