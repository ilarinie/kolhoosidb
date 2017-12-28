class CreateCommuneLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :commune_logs do |t|
      t.integer :commune_id
      t.string :message

      t.timestamps
    end
  end
end
