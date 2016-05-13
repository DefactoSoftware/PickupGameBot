class PickupBot
  attr_reader :telegram_bot

  def initialize(telegram_bot)
    @telegram_bot = telegram_bot
  end

  def run(message)
    begin
      handle_command(message)
    rescue => exception
      Rails.logger.error exception.message
      PickupBot::Commands::Error.run(telegram_bot, message, exception)
    end
  end

    private

  def handle_command(message)
    case message.text
    when /help/
      PickupBot::Commands::Help.run(telegram_bot, message)
    when /status/
      PickupBot::Commands::Status.run(telegram_bot, message)
    when /create_game/
      PickupBot::Commands::CreateGame.run(telegram_bot, message)
    when /archive_game/
      PickupBot::Commands::ArchiveGame.run(telegram_bot, message)
    when /join/
      PickupBot::Commands::Join.run(telegram_bot, message)
    when /leave/
      PickupBot::Commands::Leave.run(telegram_bot, message)
    else
      PickupBot::Commands::Error.run(telegram_bot, message, exception)
    end
  end
end

require 'pickup_bot/commands'
