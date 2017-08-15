class CreateInvitations < ActiveRecord::Migration[5.1]
  def change
    create_table :invitations do |t|
      t.integer :user_id
      t.integer :commune_id

      t.timestamps
    end
  end
end
