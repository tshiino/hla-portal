class AddDammiesToHlas < ActiveRecord::Migration
  def change
    add_column :hlas, :dserotype, :string, :limit => 4
    add_column :hlas, :dallele, :string, :limit => 16
  end
end
