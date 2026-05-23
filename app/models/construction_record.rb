class ConstructionRecord < ApplicationRecord
  belongs_to :user
  belongs_to :project, optional: true

  has_many_attached :photos
  serialize :photo_captions, coder: JSON

  MAX_PHOTOS = 10

  validates :worked_on, presence: true
  validates :site, presence: true
  validate :photos_count_within_limit

  scope :recent, -> { order(worked_on: :desc) }

  private

  def photos_count_within_limit
    errors.add(:photos, "は最大#{MAX_PHOTOS}枚まで添付できます") if photos.count > MAX_PHOTOS
  end
end
