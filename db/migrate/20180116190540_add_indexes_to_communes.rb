class AddIndexesToCommunes < ActiveRecord::Migration[5.1]
  def change
    add_index :purchases, :created_at
  end
end
