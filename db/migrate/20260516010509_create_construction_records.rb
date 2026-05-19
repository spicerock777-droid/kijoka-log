class CreateConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    create_table :construction_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :worked_on, null: false
      t.string :site, null: false
      t.text :work_items
      t.text :intent
      t.text :observations
      t.text :next_steps

      t.timestamps
    end
  end
end
