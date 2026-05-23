namespace :storage do
  desc "ローカルのActive Storage写真をCloudinaryに一括移行する"
  task migrate_to_cloudinary: :environment do
    blobs = ActiveStorage::Blob.all
    puts "#{blobs.count}ファイルを移行します..."

    blobs.each do |blob|
      blob.open do |tmp|
        Cloudinary::Uploader.upload(
          tmp.path,
          public_id: blob.key,
          resource_type: "auto",
          overwrite: false
        )
        puts "完了: #{blob.filename}"
      end
    rescue => e
      puts "エラー: #{blob.filename} - #{e.message}"
    end

    puts "移行完了！"
  end
end
