module Commands
  class Help
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      telegram_bot.api.send_message(chat_id: message.chat.id, text: text)
    end

    private

    attr_reader :telegram_bot, :message

    def text
      "Whatever, @#{username}"
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
