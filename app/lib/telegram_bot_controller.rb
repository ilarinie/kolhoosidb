class TelegramApi
  require 'telegram/bot'




  def self.send_to_channel commune, message
    if not ENV["TELEGRAM_BOT_TOKEN"].nil? && commune.telegram_channel_token.nil?
      @token =  ENV["TELEGRAM_BOT_TOKEN"]
      Telegram::Bot::Client.run(@token) do |bot|
        bot.api.send_message(chat_id: commune.telegram_channel_token, text: message)
      end
    end
  end
end