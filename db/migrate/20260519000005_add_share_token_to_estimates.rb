class AddShareTokenToEstimates < ActiveRecord::Migration[8.1]
  def change
    add_column :estimates, :share_token, :string
    add_index :estimates, :share_token, unique: true
  end
end
