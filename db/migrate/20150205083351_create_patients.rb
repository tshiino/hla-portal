class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :niid_id, :limit => 16
      t.string :lab_id, :limit => 16
      t.string :affiliation, :limit => 16
      t.string :hosp_id, :limit => 16
      t.string :gender, :limit => 16
      t.string :nationarity, :limit => 4
      t.date :date_of_birth
      t.date :date_diagnosed
      t.string :edu_background, :limit => 32
      t.string :occupation, :limit => 128
      t.string :marital_status, :limit => 16
      t.string :risk, :limit => 16
      t.integer :operator_id

      t.timestamps null: false
    end
  end
end
