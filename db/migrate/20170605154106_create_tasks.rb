class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.integer :commune_id
      t.string :name
      t.integer :priority

      t.timestamps
    end
  end
end
