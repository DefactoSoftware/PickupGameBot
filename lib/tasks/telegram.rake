namespace :telegram do
  task run: [:environment] do
    require 'pickup_bot'
    require 'telegram/bot'

    token = ENV['TELEGRAM_TOKEN']

    Telegram::Bot::Client.run(token) do |bot|
      pickup_bot = PickupBot.new(bot)

      bot.listen do |message|
        pickup_bot.run(message)
      end
    end
  end
end
