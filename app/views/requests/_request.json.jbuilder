json.extract! request, :id, :user_id, :laboratory_id, :created_at, :updated_at
json.url request_url(request, format: :json)
