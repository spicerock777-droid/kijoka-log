class ClearShareTokenExpiry < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE estimates SET share_token_expires_at = NULL"
    execute "UPDATE invoices SET share_token_expires_at = NULL"
    execute "UPDATE receipts SET share_token_expires_at = NULL"
  end

  def down
    # irreversible
  end
end
