json.extract! site, :id, :name, :address, :website, :user_id, :created_at, :updated_at
json.url site_url(site, format: :json)
