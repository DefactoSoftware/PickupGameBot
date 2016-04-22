class PickupBot
  attr_reader :telegram_bot

  def initialize(telegram_bot)
    @telegram_bot = telegram_bot
  end

  def run(message)
    case message.text
    when /help/
      PickupBot::Commands::Help.run(telegram_bot, message)
    when /status/
      PickupBot::Commands::Status.run(telegram_bot, message)
    when /create_game/
      PickupBot::Commands::CreateGame.run(telegram_bot, message)
    when /join/
      PickupBot::Commands::Join.run(telegram_bot, message)
    when /leave/
      PickupBot::Commands::Leave.run(telegram_bot, message)
    end
  end
end

require 'pickup_bot/commands'
