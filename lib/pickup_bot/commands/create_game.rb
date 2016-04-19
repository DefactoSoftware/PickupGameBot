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
      if game_exists?
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.commands.create_game.game_exists', username: username)
        )
      else
        required_players = message.text.split(" ").second.to_i
        game = Game.new(
          chat_id: @message.chat.id,
          name: game_name,
          required_players: required_players
          )
        game.save

        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.commands.create_game.game_created', username: username)
        )
      end
    end

    private

    attr_reader :telegram_bot, :message

    def game_exists?
      return true if Game.find_by_chat_id(@message.chat.id)
    end

    def game_name
      "#{@message.chat.title}'s game"
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
