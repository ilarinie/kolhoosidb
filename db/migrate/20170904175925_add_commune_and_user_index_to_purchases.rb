class AddCommuneAndUserIndexToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_index(:purchases, :user_id)
    add_index(:purchases, :commune_id)
  end
end
