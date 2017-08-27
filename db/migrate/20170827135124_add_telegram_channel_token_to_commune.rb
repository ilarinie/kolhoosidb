class AddTelegramChannelTokenToCommune < ActiveRecord::Migration[5.1]
  def change
    add_column :communes, :telegram_channel_token, :string
  end
end
