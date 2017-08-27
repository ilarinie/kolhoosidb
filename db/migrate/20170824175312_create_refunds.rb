class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds do |t|
      t.integer :to
      t.integer :from
      t.decimal :amount

      t.timestamps
    end
  end
end
