class CreateSerotypeMasterBs < ActiveRecord::Migration
  def change
    create_table :serotype_master_bs do |t|
      t.string :name, :limit => 4
      t.integer :priority

      t.timestamps null: false
    end
  end
end
