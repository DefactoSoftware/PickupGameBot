module Commands
  class Kick
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      return destroy_user_attendance if user_attendance
    end

    private

    def kick_username
      @message.text.split(" ").second
    end

    def current_game
      Game.active.find_by_chat_id(@message.chat.id)
    end

    def kicked_player
      Player.find_by(username: kick_username)
    end

    def user_attendance
      Attendance.find_by(game: current_game, player: kicked_player )
    end

    def destroy_user_attendance
      user_attendance.destroy
      @telegram_bot.api.send_message(
        chat_id: @message.chat.id,
        text: I18n.t("bot.kick_user")
      )
    end

  end
end
