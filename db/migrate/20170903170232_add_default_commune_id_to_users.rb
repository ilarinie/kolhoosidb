class AddDefaultCommuneIdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :default_commune_id, :integer
  end
end
