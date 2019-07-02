require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "add date to a game" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:existing_game) { Game.new(chat_id: fake_chat_id) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "player tries to add a date" do
      message = Telegram::Bot::Types::Message.new(message_params('/add_date monday'))

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.no_game",
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end
  end

  context "an active game exists" do
    scenario "player tries to add monday as a weekday" do
      message = Telegram::Bot::Types::Message.new(message_params('/add_date monday'))

      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.date",
                  username: user_params[:username],
                  date: "Monday"
                )
              }
            )).to have_been_made.times(1)
    end

    scenario "player tries to add a data with an integer" do
      message = Telegram::Bot::Types::Message.new(message_params('/add_date monday'))

      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.time",
                  username: user_params[:username],
                  time: "06:00"
                )
              }
            )).to have_been_made.times(1)
      expect(Game.last.time).to eq "06:00"
    end

    scenario "player tries to add a date with month and day" do
      message = Telegram::Bot::Types::Message.new(message_params('/add_date 07-12'))

      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.date",
                  date: "Saturday"
                )
              }
            )).to have_been_made.times(1)
    end
  end
end
