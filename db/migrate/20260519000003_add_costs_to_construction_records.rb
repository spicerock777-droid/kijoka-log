class AddCostsToConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :construction_records, :construction_cost, :integer
    add_column :construction_records, :labor_cost, :integer
    add_column :construction_records, :cost_memo, :text
  end
end
