class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :laboratory, foreign_key: true

      t.timestamps
    end
  end
end
