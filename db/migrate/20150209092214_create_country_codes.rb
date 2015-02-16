class CreateCountryCodes < ActiveRecord::Migration
  def change
    create_table :country_codes do |t|
      t.string :code, :limit => 4
      t.string :country

      t.timestamps null: false
    end
  end
end
