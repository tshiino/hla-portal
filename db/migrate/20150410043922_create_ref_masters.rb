class CreateRefMasters < ActiveRecord::Migration
  def change
    create_table :ref_masters do |t|
      t.string :name
      t.string :type
      t.integer :start
      t.integer :end
      t.integer :length
      t.text :sequence
      t.string :subtype, limit: 8
      t.string :accession, limit: 16

      t.timestamps null: false
    end
    add_index :ref_masters, :name
  end
end
