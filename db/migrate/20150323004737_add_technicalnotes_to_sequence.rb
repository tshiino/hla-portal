class AddTechnicalnotesToSequence < ActiveRecord::Migration
  def change
    add_column :sequences, :clonal, :boolean
    add_column :sequences, :provirus, :boolean
    add_column :sequences, :notes, :string
    add_column :sequences, :operator_id, :integer
  end
end
