class AddShareTokenToInvoices < ActiveRecord::Migration[8.1]
  def change
    add_column :invoices, :share_token, :string
    add_index  :invoices, :share_token, unique: true
    add_column :invoices, :share_token_expires_at, :datetime
  end
end
