class CreateMutations < ActiveRecord::Migration
  def change
    create_table :mutations do |t|
      t.references :sequence, index: true
      t.string :gene, limit: 8
      t.string :wildtype, limit: 4
      t.integer :locus
      t.string :mutated

      t.timestamps null: false
    end
    add_foreign_key :mutations, :sequences
    add_index :mutations, [ :gene, :locus ]
  end
end
