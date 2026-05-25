class MigratePhotoMetadata < ActiveRecord::Migration[8.1]
  TYPE_MAP = { "before" => 0, "during" => 1, "after" => 2 }.freeze

  def up
    migrate_construction_records
    migrate_ws_logs
  end

  def down
    execute("DELETE FROM photos WHERE record_type IN ('ConstructionRecord', 'WsLog')")
  end

  private

  def migrate_construction_records
    connection.select_all("SELECT id, photo_captions, photo_types FROM construction_records").each do |cr|
      captions = JSON.parse(cr["photo_captions"] || "{}") rescue {}
      types    = JSON.parse(cr["photo_types"]    || "{}") rescue {}

      attachments = connection.select_all(<<~SQL)
        SELECT blob_id FROM active_storage_attachments
        WHERE record_type = 'ConstructionRecord' AND record_id = #{cr["id"]}
        ORDER BY created_at ASC
      SQL

      attachments.each_with_index do |att, pos|
        bid      = att["blob_id"].to_s
        ptype    = TYPE_MAP.fetch(types[bid], 1)
        caption  = connection.quote(captions[bid])

        connection.execute(<<~SQL)
          INSERT INTO photos (record_type, record_id, blob_id, photo_type, caption, position, created_at, updated_at)
          VALUES ('ConstructionRecord', #{cr["id"]}, #{att["blob_id"]}, #{ptype}, #{caption}, #{pos}, NOW(), NOW())
        SQL
      end
    end
  end

  def migrate_ws_logs
    connection.select_all("SELECT id FROM ws_logs").each do |ws|
      connection.select_all(<<~SQL).each_with_index do |att, pos|
        SELECT blob_id FROM active_storage_attachments
        WHERE record_type = 'WsLog' AND record_id = #{ws["id"]}
        ORDER BY created_at ASC
      SQL
        connection.execute(<<~SQL)
          INSERT INTO photos (record_type, record_id, blob_id, photo_type, caption, position, created_at, updated_at)
          VALUES ('WsLog', #{ws["id"]}, #{att["blob_id"]}, 1, NULL, #{pos}, NOW(), NOW())
        SQL
      end
    end
  end
end
