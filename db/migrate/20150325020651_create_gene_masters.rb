class CreateGeneMasters < ActiveRecord::Migration
  def change
    create_table :gene_masters do |t|
      t.string :name, limit: 8
      t.integer :start
      t.integer :end
      t.boolean :hiv2

      t.timestamps null: false
    end
  end
end
