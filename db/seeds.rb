projects_data = [
  {
    name: "P波",
    slug: "p-ha",
    sites: ["全体", "その他"]
  },
  {
    name: "K翔",
    slug: "k-sho",
    sites: ["K翔右・駐車場周り", "駐車場裏の森", "段々畑", "U字側溝沿い", "その他"]
  },
  {
    name: "H・bistro",
    slug: "h-bistro",
    sites: ["フィールド全体", "その他"]
  },
  {
    name: "Os fam",
    slug: "os-fam",
    sites: ["造成駐車場", "その他"]
  },
  {
    name: "Tu bamY",
    slug: "tu-bamy",
    sites: ["森全体", "その他"]
  },
  {
    name: "HanaY fam",
    slug: "hanay-fam",
    sites: ["スロープ予定地", "その他"]
  }
]

projects_data.each do |data|
  Project.find_or_create_by!(slug: data[:slug]) do |p|
    p.name = data[:name]
    p.sites = data[:sites]
  end
end

# 既存のConstructionRecordをK翔プロジェクトに紐づける
k_sho = Project.find_by!(slug: "k-sho")
ConstructionRecord.where(project_id: nil).update_all(project_id: k_sho.id)
