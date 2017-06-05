class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.integer :generate_by
      t.datetime :begin_dt
      t.datetime :end_dt
      t.boolean :unit
      t.boolean :state
      t.boolean :kind
      t.boolean :onu
      t.boolean :blend
      t.boolean :code
      t.boolean :total
      t.belongs_to :collection, foreign_key: true

      t.timestamps
    end
  end
end
