module PickupBot::Commands
  class SetLocation
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      if game_exists?
        location = Location.create(
          longitude: @message.location.longitude,
          latitude: @message.location.latitude,
          game: game
        )
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.location_set')
        )
      end
    end

    private

    attr_reader :telegram_bot, :message

    def game_exists?
      Game.active.exists?(chat_id: @message.chat.id)
    end

    def game
      @game ||= Game.find_by_chat_id(@message.chat.id)
    end

    def game_name
      "#{@message.chat.title}'s game" || "#{username}'s game"
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
