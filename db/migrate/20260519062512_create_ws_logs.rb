class CreateWsLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :ws_logs do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :held_on
      t.string :title
      t.integer :participants_count
      t.string :participant_notes
      t.string :weather
      t.text :content
      t.text :reflection
      t.text :reactions
      t.text :improvements

      t.timestamps
    end
  end
end
