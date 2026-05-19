class Estimate < ApplicationRecord
  belongs_to :project
  belongs_to :user

  before_create :generate_share_token

  validates :doc_date, presence: true

  scope :recent, -> { order(doc_date: :desc) }
  scope :search, ->(q) {
    where("client_name ILIKE :q OR subject ILIKE :q", q: "%#{q}%") if q.present?
  }

  def subtotal
    items.sum { |item| (item["qty"].to_f * item["unit_price"].to_f).round }
  end

  def tax
    (subtotal * 0.1).floor
  end

  def grand_total
    subtotal + tax
  end

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(12)
  end
end
