class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.integer :user_id
      t.integer :commune_id
      t.decimal :amount
      t.string :description

      t.timestamps
    end
  end
end
