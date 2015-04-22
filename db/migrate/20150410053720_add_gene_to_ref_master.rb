class AddGeneToRefMaster < ActiveRecord::Migration
  def change
    add_column :ref_masters, :gene, :string, limit: 8
  end
end
