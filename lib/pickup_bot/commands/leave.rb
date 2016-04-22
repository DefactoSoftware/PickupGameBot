module Commands
  class Leave
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      return destroy_current_attendance if current_attendance
      cannot_leave_notice
    end

    private

    attr_reader :telegram_bot, :message

    def cannot_leave_notice
      if game_exists?
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t("bot.commands.leave.not_attending", username: username)
        )
      else
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t("bot.commands.leave.no_game", username: username)
        )
      end
    end

    def destroy_current_attendance
      current_attendance.destroy

      telegram_bot.api.send_message(
        chat_id: message.chat.id,
        text: I18n.t("bot.commands.leave.left",
        username: username,
        players: players
        )
      )
    end

    def game_exists?
      Game.exists?(chat_id: @message.chat.id)
    end

    def current_game
      Game.find_by_chat_id(@message.chat.id)
    end

    def current_attendance
      Attendance.find_by(game: current_game, player: current_player)
    end

    def current_player
      Player.find_by(telegram_user_id: message.from.id)
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
