class AddPhotoTypesToConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :construction_records, :photo_types, :text
  end
end
