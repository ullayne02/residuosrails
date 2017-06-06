class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.string :message
      t.belongs_to :collection, index: true, foreign_key: true
      t.belongs_to :request, index: true, foreign_key: true

      t.timestamps
    end
  end
end
