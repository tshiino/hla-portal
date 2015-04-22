class CreateSubtypeMasters < ActiveRecord::Migration
  def change
    create_table :subtype_masters do |t|
      t.string :name, limit: 16
      t.string :code, limit: 4
      t.string :structure

      t.timestamps null: false
    end
  end
end
