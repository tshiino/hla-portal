class ChangeAttrOfAffiliation < ActiveRecord::Migration
  def change
    change_column :users, :affiliation, :integer
  end
end
