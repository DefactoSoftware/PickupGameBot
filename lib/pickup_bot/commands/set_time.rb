# frozen_string_literal: true

module PickupBot::Commands
  class SetTime
    def self.run(telegram_bot, message)
      new(telegram_bot, message).run
    end

    def initialize(telegram_bot, message)
      @telegram_bot = telegram_bot
      @message = message
    end

    def run
      return no_game_message(message) unless game_exists?

      if current_game.update(datetime: datetime)
        telegram_bot.api.send_message(
          chat_id: message.chat.id,
          text: I18n.t('bot.date', date: I18n.l(datetime, format: :long))
        )
      end
    end

    private

    attr_reader :telegram_bot, :message

    def no_game_message(message)
      telegram_bot.api.send_message(
        chat_id: message.chat.id,
        text: I18n.t('bot.no_game', username: username)
      )
    end

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
        current_game.players.count.to_s
      end
    end

    def username
      message.from.username || message.from.first_name
    end

    def game_date?
      current_game.blank?
    end

    def datetime
      @datetime ||= @message.text
                            .then { |x| x.split(' ', 2).last.strip }
                            .then { |x| Chronic.parse(x) }
    end
  end
end
