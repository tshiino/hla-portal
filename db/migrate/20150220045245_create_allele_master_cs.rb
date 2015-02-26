class CreateAlleleMasterCs < ActiveRecord::Migration
  def change
    create_table :allele_master_cs do |t|
      t.string :name, :limit => 16
      t.integer :priority
      t.references :serotype_master_c, index: true

      t.timestamps null: false
    end
    add_foreign_key :allele_master_cs, :serotype_master_cs
  end
end
