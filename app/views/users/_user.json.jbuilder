json.extract! user, :id, :name, :last_name, :email, :password, :birthday, :gender, :place, :number, :complement, :cep, :district, :city, :state, :country, :phone, :cell_phone, :kind, :created_at, :updated_at
json.url user_url(user, format: :json)
