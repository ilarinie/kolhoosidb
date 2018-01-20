class AddDateIndexToTaskCompletion < ActiveRecord::Migration[5.1]
  def change
    add_index :task_completions, :created_at
  end
end
