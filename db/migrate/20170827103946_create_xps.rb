class CreateXps < ActiveRecord::Migration[5.1]
  def change
    create_table :xps do |t|
      t.integer :points
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
