class CreateCommuneUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :commune_users do |t|
      t.integer :user_id
      t.integer :commune_id
      t.boolean :admin

      t.timestamps
    end
  end
end
