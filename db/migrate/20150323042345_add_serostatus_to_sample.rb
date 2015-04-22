class AddSerostatusToSample < ActiveRecord::Migration
  def change
    add_column :samples, :serostatus, :integer
  end
end
