module PickupBot::Commands
  class AddDate
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
          text: I18n.t("bot.date", date: date)
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

    def date
      @message.text
        .then { |x| x.split(" ", 2).last.strip }
        .then { |string| string_to_date(string) }
        .then { |date| save_date(date) }
        .then { |date| return_date(date) }
    end

    def save_date(date)
      current_game.update(date: "#{date.wday}-#{date.month}")
      date
    end

    def return_date(date)
      if (date - 7) > 0
       Date::DAYNAMES[date.wday]
      else
        "#{date.wday}-#{date.month}"
      end
    end

    def string_to_date(string)
      today = Date.today
      if Date::DAYNAMES.include?(string.capitalize)
      date = Date.parse(string)
        if date < today
          date + 7
        else
          date
        end
      else
        string.split("-", 2)
          .then { |x| Date.parse("#{today.year}-#{x.last}-#{x.first}") }
      end
    end
  end
end
