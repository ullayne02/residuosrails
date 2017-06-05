class CreateRegisters < ActiveRecord::Migration[5.0]
  def change
    create_table :registers do |t|
      t.float :weight
      t.belongs_to :residue, foreign_key: true

      t.timestamps
    end
  end
end
