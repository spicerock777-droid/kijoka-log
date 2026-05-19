class Receipt < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :received_on, :amount, presence: true

  scope :recent, -> { order(received_on: :desc) }
end
