class CreateResidues < ActiveRecord::Migration[5.0]
  def change
    create_table :residues do |t|
      t.string :name
      t.string :kind
      t.string :blend
      t.string :onu
      t.string :code
      t.belongs_to :laboratory, foreign_key: true
      t.belongs_to :collection, foreign_key: true

      t.timestamps
    end
  end
end
