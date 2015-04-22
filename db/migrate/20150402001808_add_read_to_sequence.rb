class AddReadToSequence < ActiveRecord::Migration
  def change
    add_column :sequences, :read, :integer
  end
end
