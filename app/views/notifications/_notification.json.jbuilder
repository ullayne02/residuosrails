json.extract! notification, :id, :message, :collection_id, :request_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)
