class AllowNullSiteInConstructionRecords < ActiveRecord::Migration[8.1]
  def change
    change_column_null :construction_records, :site, true, ""
  end
end
