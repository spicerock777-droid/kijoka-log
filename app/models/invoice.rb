class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :user

  before_create :generate_share_token

  validates :invoiced_on, :amount, presence: true

  scope :recent, -> { order(invoiced_on: :desc) }

  def share_token_expired?
    share_token_expires_at.present? && share_token_expires_at < Time.current
  end

  private

  def generate_share_token
    self.share_token = SecureRandom.urlsafe_base64(12)
  end

end
