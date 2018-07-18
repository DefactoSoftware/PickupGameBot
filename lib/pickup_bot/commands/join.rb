module PickupBot::Commands
  class Join
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      if game_exists?
        current_player = Player.find_or_create_by(telegram_user_id: message.from.id)
        unless current_player.username
          current_player.update(username: username)
        end
        attendence = Attendance.new(game: current_game, player: current_player)
        attendence.save
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t(
            "bot.joined_game",
            username: username,
            players: players
          )
        )
      else
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t("bot.no_game", username: username)
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
