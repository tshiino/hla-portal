class AddAccessionToSequence < ActiveRecord::Migration
  def change
    add_column :sequences, :accession, :string, :limit => 16
  end
end
