class AddCommuneIdToRefunds < ActiveRecord::Migration[5.1]
  def change
    add_column :refunds, :commune_id, :integer
    add_index :refunds, :commune_id
    add_index :refunds, [:commune_id, :from]
    add_index :refunds, [:commune_id, :to]
  end
end
