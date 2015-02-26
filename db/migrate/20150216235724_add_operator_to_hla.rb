class AddOperatorToHla < ActiveRecord::Migration
  def change
    add_column :hlas, :operator_id, :integer
  end
end
