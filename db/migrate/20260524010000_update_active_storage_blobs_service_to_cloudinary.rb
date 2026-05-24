class UpdateActiveStorageBlobsServiceToCloudinary < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE active_storage_blobs SET service_name = 'cloudinary' WHERE service_name = 'local'"
  end

  def down
    execute "UPDATE active_storage_blobs SET service_name = 'local' WHERE service_name = 'cloudinary'"
  end
end
