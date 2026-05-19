class AddShareTokenToReceipts < ActiveRecord::Migration[8.1]
  def change
    add_column :receipts, :share_token, :string
    add_index  :receipts, :share_token, unique: true
    add_column :receipts, :share_token_expires_at, :datetime
  end
end
