class AddCommuneIdIndexToTasks < ActiveRecord::Migration[5.1]
  def change
    add_index(:tasks, :commune_id)
  end
end
