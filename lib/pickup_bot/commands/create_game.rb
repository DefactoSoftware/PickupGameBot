module Commands
  class CreateGame
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      game = Game.new(
        chat_id: @message.chat.id,
        name: game_name
        )
      game.save
      telegram_bot.api.send_message(chat_id: message.chat.id, text: text)
    end

    private

    attr_reader :telegram_bot, :message

    def game_name
      "#{@message.chat.title}'s game"
    end

    def text
      "Game has been created, @#{username}"
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
