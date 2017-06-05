class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :last_name
      t.string :email
      t.string :password
      t.date :birthday
      t.string :gender
      t.string :place
      t.integer :number
      t.string :complement
      t.string :cep
      t.string :district
      t.string :city
      t.string :state
      t.string :country
      t.string :phone
      t.string :cell_phone
      t.string :kind

      t.timestamps
    end
  end
end
