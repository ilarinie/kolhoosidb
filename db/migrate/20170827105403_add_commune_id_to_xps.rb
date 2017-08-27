class AddCommuneIdToXps < ActiveRecord::Migration[5.1]
  def change
    add_column :xps, :commune_id, :integer
  end
end
