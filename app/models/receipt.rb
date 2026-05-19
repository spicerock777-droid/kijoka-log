class Receipt < ApplicationRecord
  belongs_to :project
  belongs_to :user

  before_create :generate_share_token
  before_create :set_share_token_expiry

  validates :received_on, :amount, presence: true

  scope :recent, -> { order(received_on: :desc) }

  def share_token_expired?
    share_token_expires_at.present? && share_token_expires_at < Time.current
  end

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(12)
  end

  def set_share_token_expiry
    self.share_token_expires_at = 30.days.from_now
  end
end
