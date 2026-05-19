class WsLog < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many_attached :photos

  validates :held_on, :title, presence: true

  scope :recent, -> { order(held_on: :desc) }
end
