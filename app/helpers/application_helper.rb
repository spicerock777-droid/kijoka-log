module ApplicationHelper
  # スマホからアクセス可能な公開URL（ngrok等）
  # APP_PUBLIC_URL 環境変数が設定されていればそちらを優先
  def public_base_url
    ENV["APP_PUBLIC_URL"].presence || request.base_url
  end
end
