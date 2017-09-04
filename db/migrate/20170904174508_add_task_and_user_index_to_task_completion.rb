class AddTaskAndUserIndexToTaskCompletion < ActiveRecord::Migration[5.1]
  def change
    add_index(:task_completions, :task_id)
    add_index(:task_completions, :user_id)
  end
end
