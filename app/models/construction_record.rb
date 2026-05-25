class ConstructionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  has_many :photos, as: :record, dependent: :destroy

  validates :worked_on, presence: true
  validates :project, presence: true
  validates :work_items, presence: true

  scope :recent,      -> { order(worked_on: :desc) }
  scope :with_photos, -> { joins(:photos).distinct }
end
