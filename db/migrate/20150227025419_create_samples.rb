class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.references :patient, index: true
      t.date :date_sample_taken
      t.boolean :art_status
      t.string :art_formula, limit: 64
      t.float :cd4_count
      t.date :date_cd4_exam
      t.float :viral_load
      t.string :condition, limit: 32
      t.string :remarks
      t.integer :operator_id

      t.timestamps null: false
    end
    add_foreign_key :samples, :patients
    add_index :samples, [ :art_status, :cd4_count, :viral_load ]
  end
end
