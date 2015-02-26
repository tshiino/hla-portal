class CreateAlleleMasterAs < ActiveRecord::Migration
  def change
    create_table :allele_master_as do |t|
      t.string :name, :limit => 16
      t.integer :priority
      t.references :serotype_master_a, index: true

      t.timestamps null: false
    end
    add_foreign_key :allele_master_as, :serotype_master_as
  end
end
