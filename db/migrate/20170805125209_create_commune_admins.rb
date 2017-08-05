class CreateCommuneAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :commune_admins do |t|
      t.integer :user_id
      t.integer :commune_id

      t.timestamps
    end
  end
end
