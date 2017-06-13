json.extract! report, :id, :generate_by, :begin_dt, :end_dt, :unit, :state, :kind, :onu, :blend, :code, :total, :collection_id, :created_at, :updated_at
json.url report_url(report, format: :json)
