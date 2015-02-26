class AddIndexToHlas < ActiveRecord::Migration
  def change
    add_index :hlas, :type
  end
end
