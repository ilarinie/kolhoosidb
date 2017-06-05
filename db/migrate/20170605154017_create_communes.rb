class CreateCommunes < ActiveRecord::Migration[5.1]
  def change
    create_table :communes do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
