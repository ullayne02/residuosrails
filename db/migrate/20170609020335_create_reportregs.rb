class CreateReportregs < ActiveRecord::Migration[5.0]
  def change
    create_table :reportregs do |t|
      t.float :weight
      t.belongs_to :report, index: true, foreign_key: true

      t.timestamps
    end
  end
end
