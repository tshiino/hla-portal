class CreateAlleleMasterBs < ActiveRecord::Migration
  def change
    create_table :allele_master_bs do |t|
      t.string :name, :limit => 16
      t.integer :priority
      t.references :serotype_master_b, index: true

      t.timestamps null: false
    end
    add_foreign_key :allele_master_bs, :serotype_master_bs
  end
end
