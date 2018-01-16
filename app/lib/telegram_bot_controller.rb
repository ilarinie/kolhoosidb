class TelegramApi
  require "telegram/bot"

  def self.send_to_channel (commune, message, no_notification)

    if commune.telegram_channel_token.nil?
      return
    end

    if ENV["TELEGRAM_BOT_TOKEN"].nil?
      return
    end
    @token =  ENV["TELEGRAM_BOT_TOKEN"]
    Telegram::Bot::Client.run(@token) do |bot|
      bot.api.send_message(chat_id: commune.telegram_channel_token, text: message, disable_notification: no_notification)
    end
  end
end