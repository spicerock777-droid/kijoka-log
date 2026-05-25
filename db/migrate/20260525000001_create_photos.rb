class CreatePhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :photos do |t|
      t.references :record, polymorphic: true, null: false
      t.references :blob, null: false, foreign_key: { to_table: :active_storage_blobs }
      t.integer    :photo_type, null: false, default: 1
      t.text       :caption
      t.integer    :position, null: false, default: 0
      t.timestamps
    end

    add_index :photos, :photo_type
  end
end
