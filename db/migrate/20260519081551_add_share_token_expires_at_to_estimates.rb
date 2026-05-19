class AddShareTokenExpiresAtToEstimates < ActiveRecord::Migration[8.1]
  def change
    add_column :estimates, :share_token_expires_at, :datetime
  end
end
