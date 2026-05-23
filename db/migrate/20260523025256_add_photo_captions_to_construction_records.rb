class AddPhotoCaptionsToConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    add_column :construction_records, :photo_captions, :text
  end
end
