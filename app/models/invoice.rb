class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :invoiced_on, :amount, presence: true

  scope :recent, -> { order(invoiced_on: :desc) }
end
