class AddUserIdToCommune < ActiveRecord::Migration[5.1]
  def change
    add_column :communes, :user_id, :integer
  end
end
