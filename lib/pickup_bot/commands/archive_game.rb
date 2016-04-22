module Commands
  class ArchiveGame
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      if game_exists?
        current_game.archive!
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.game_archived', username: username)
        )
      else
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.no_game', username: username)
        )
      end
    end

    private

    attr_reader :telegram_bot, :message

    def game_exists?
      Game.exists?(chat_id: @message.chat.id)
    end

    def current_game
      Game.find_by_chat_id(@message.chat.id)
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
