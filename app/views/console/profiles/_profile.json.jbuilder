json.extract! profile, :id, :user_id, :location, :company, :tagline, :created_at, :updated_at
json.url profile_url(profile, format: :json)
