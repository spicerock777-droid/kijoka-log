class CreateEstimates < ActiveRecord::Migration[8.1]
  def change
    create_table :estimates do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :client_name
      t.string :subject
      t.date :doc_date, null: false
      t.string :doc_number
      t.jsonb :items, default: []
      t.text :note
      t.timestamps
    end
  end
end
