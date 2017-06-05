class CreateTaskCompletions < ActiveRecord::Migration[5.1]
  def change
    create_table :task_completions do |t|
      t.integer :user_id
      t.integer :task_id

      t.timestamps
    end
  end
end
