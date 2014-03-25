class CreateInstitutesMasters < ActiveRecord::Migration
  def change
    create_table :institutes_masters do |t|
      t.string :name

      t.timestamps
    end
  end
end
