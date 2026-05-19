class AddApplyTaxToEstimates < ActiveRecord::Migration[8.1]
  def change
    add_column :estimates, :apply_tax, :boolean, default: true, null: false
  end
end
