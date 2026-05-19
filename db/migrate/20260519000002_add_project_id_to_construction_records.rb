class AddProjectIdToConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    add_reference :construction_records, :project, null: true, foreign_key: true
  end
end
