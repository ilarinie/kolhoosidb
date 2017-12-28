class AddLongMessageToCommuneLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :commune_logs, :long_message, :string
  end
end
