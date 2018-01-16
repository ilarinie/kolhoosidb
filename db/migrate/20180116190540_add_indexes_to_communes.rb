class AddIndexesToCommunes < ActiveRecord::Migration[5.1]
  def change
    add_index :tasks, :commune_id
    add_index :task_completions, :task_id
    add_index :commune_users, [:user_id, :commune_id], :unique => true
    add_index :commune_admins, [:user_id, :commune_id], :unique => true
    add_index :purchases, :commune_id
    add_index :refunds, :commune_id
    add_index :refunds, :to_id
    add_index :refunds, :from_id
    add_index :xps, :user_id
    add_index :purchase_categories, :commune_id
  end
end
