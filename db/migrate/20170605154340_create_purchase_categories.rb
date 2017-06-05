class CreatePurchaseCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :purchase_categories do |t|
      t.integer :commune_id
      t.string :name

      t.timestamps
    end
  end
end
