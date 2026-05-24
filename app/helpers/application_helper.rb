module ApplicationHelper
  def public_base_url
    ENV["APP_PUBLIC_URL"].presence || request.base_url
  end

  # ngrok経由の共有URL（警告ページをスキップするパラメータ付き）
  def public_share_url(path)
    base = public_base_url
    sep = path.include?("?") ? "&" : "?"
    "#{base}#{path}#{sep}ngrok-skip-browser-warning=true"
  end

  def photo_url(photo, width:, height:, crop: :fill)
    Cloudinary::Utils.cloudinary_url(photo.blob.key, width: width, height: height, crop: crop, fetch_format: :auto, quality: :auto)
  end
end
