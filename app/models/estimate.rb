class Estimate < ApplicationRecord
  belongs_to :project
  belongs_to :user

  before_create :generate_share_token

  validates :doc_date, presence: true

  scope :recent, -> { order(doc_date: :desc) }
  scope :search, ->(q) {
    where("client_name ILIKE :q OR subject ILIKE :q", q: "%#{q}%") if q.present?
  }

  def work_subtotal
    items.sum do |item|
      prices = item["unit_prices"]
      if prices.present? && prices.length > 1
        prices.sum { |p| p.to_f.round }
      else
        (item["qty"].to_f * item["unit_price"].to_f).round
      end
    end
  end

  def material_subtotal
    items.sum do |item|
      mats = item["materials"].presence || (item["material_cost"].present? ? [{ "cost" => item["material_cost"] }] : [])
      mats.sum { |m| m["cost"].to_i }
    end
  end

  def subtotal
    work_subtotal + material_subtotal
  end

  def tax
    return 0 unless apply_tax
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
