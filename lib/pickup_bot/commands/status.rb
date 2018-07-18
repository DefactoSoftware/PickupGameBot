module PickupBot::Commands
  class Status
    include ActionView::Helpers
    include ActionDispatch::Routing
    include Rails.application.routes.url_helpers

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
          parse_mode: "markdown",
          text: I18n.t(
                  "bot.game_status",
                  players: players,
                  game_url: game_url(current_game),
                )
        )
      else
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t("bot.no_game", username: username),
          parse_mode: "markdown"
        )
      end
    end

    private

    attr_reader :telegram_bot, :message

    def game_exists?
      Game.active.exists?(chat_id: @message.chat.id)
    end

    def current_game
      Game.active.find_by_chat_id(@message.chat.id)
    end

    def players
      if current_game.required_players > 0
        "#{current_game.players.count} / #{current_game.required_players}"
      else
        "#{current_game.players.count}"
      end
    end

    def username
      message.from.username || message.from.first_name
    end
  end
end
