class WsLog < ApplicationRecord
  belongs_to :project
  belongs_to :user

  has_many :photos, as: :record, dependent: :destroy

  validates :held_on, :title, presence: true

  scope :recent, -> { order(held_on: :desc) }
end
