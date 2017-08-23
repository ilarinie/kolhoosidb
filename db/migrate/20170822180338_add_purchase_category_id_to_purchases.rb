class AddPurchaseCategoryIdToPurchases < ActiveRecord::Migration[5.1]
  def change
    add_column :purchases, :purchase_category_id, :integer
  end
end
