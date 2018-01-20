class AddIndexesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :commune_users, [:user_id, :commune_id], :unique => true
    add_index :commune_users, [:user_id]
    add_index :commune_users, [:commune_id]
    add_index :commune_admins, [:user_id, :commune_id], :unique => true
    add_index :commune_admins, [:user_id]
    add_index :commune_admins, [:commune_id]
  end
end
