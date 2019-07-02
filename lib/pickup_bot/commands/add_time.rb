module PickupBot::Commands
  class AddTime
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      if game_exists? && time.present?
        current_game.update(time: time)
        if game_date?
          # telegram_bot.api.send_message(
          #   chat_id: message.chat.id,
          #   text: I18n.t("bot.date_and_time", username: username, date: parse_date, time: "#{time.hour}:#{time.minute}")
          # )
        else
          telegram_bot.api.send_message(
            chat_id: message.chat.id,
            text: I18n.t("bot.time", time: time)
          )
        end
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
      !!current_game
    end

    def current_game
      @game ||= Game.active.find_by_chat_id(@message.chat.id)
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

    def game_date?
       current_game.blank?
    end

    def time
      text = @message.text
        .then { |x| x.split(" ", 2).last.strip }
        .then { |x| Time.parse(x) }
        .then { |time| "#{format('%02d', time.hour)}:#{format('%02d', time.min)}" }
    end
  end
end
