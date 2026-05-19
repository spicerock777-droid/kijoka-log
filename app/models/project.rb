class Project < ApplicationRecord
  has_many :construction_records, dependent: :destroy
  has_many :estimates, dependent: :destroy
  has_many :ws_logs, dependent: :destroy
  has_many :receipts, dependent: :destroy

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true

  def to_param
    slug
  end
end
