class ChangeNationarityToInteger < ActiveRecord::Migration
  def change
    change_column :patients, :nationarity, :integer
  end
end
