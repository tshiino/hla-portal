class AddDateOfArtInitToPatients < ActiveRecord::Migration
  def change
    add_column :patients, :date_of_art_init, :date
  end
end
