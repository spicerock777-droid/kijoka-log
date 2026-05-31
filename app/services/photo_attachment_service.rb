class PhotoAttachmentService
  MAX_PHOTOS = 10

  def initialize(record)
    @record = record
  end

  def attach(files, types = [])
    files.each_with_index do |file, i|
      next if file.blank?
      break if @record.photos.count >= MAX_PHOTOS

      blob = ActiveStorage::Blob.create_and_upload!(
        io: file,
        filename: file.original_filename,
        content_type: file.content_type
      )
      type = Photo.photo_types.key?(types[i].to_s) ? types[i].to_s : "before"
      @record.photos.create!(
        blob: blob,
        photo_type: type,
        position: @record.photos.count
      )
    end
  end

  def update_metadata(photo_updates)
    return unless photo_updates.present?

    photo_updates.each do |photo_id, attrs|
      photo = @record.photos.find_by(id: photo_id)
      next unless photo

      photo.update(
        caption:    attrs[:caption],
        photo_type: attrs[:photo_type].presence || "during"
      )
    end
  end
end
