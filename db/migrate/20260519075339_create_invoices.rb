class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.date :invoiced_on
      t.string :client_name
      t.integer :amount
      t.string :subject
      t.date :due_date
      t.text :note
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
