class AddRewardToTasks < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks, :reward, :integer
  end
end
