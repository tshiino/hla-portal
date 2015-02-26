class CreateHlas < ActiveRecord::Migration
  def change
    create_table :hlas do |t|
      t.string :type, null: false
      t.references :patient, index: true, null: false
      t.date :date_exam
      t.string :serotype, limit: 4
      t.string :allele
      t.boolean :homo, default: false

      t.timestamps null: false
    end
    add_foreign_key :hlas, :patients
    add_index :hlas, [ :serotype, :allele ]
  end
end
