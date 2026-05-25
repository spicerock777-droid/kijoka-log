class Photo < ApplicationRecord
  belongs_to :record, polymorphic: true
  belongs_to :blob, class_name: "ActiveStorage::Blob"

  enum :photo_type, { before: 0, during: 1, after: 2 }, prefix: true

  validates :photo_type, presence: true
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(position: :asc, created_at: :asc) }
end
