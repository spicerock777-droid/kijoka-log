class CreateReceipts < ActiveRecord::Migration[8.1]
  def change
    create_table :receipts do |t|
      t.date :received_on
      t.string :client_name
      t.integer :amount
      t.string :tadashi
      t.string :payment_method
      t.text :note
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
