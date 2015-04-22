class CreateSequences < ActiveRecord::Migration
  def change
    create_table :sequences do |t|
      t.references :sample, index: true
      t.date :date_seq
      t.string :gene, limit: 8
      t.integer :start
      t.integer :end
      t.integer :length
      t.text :sequence, null: false
      t.string :insertion
      t.string :subtype_code, limit: 8
      t.integer :codon_start
      t.text :translation

      t.timestamps null: false
    end
    add_foreign_key :sequences, :samples
    add_index :sequences, [ :gene, :subtype_code ]
  end
end
