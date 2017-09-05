class AddCommuneIdUserAndCreatedAtIndexToXp < ActiveRecord::Migration[5.1]
  def change
    add_index(:xps, :user_id)
    add_index(:xps, :commune_id)
    add_index(:xps, :created_at)
  end
end
