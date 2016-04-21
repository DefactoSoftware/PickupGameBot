require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "checking a game's status" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:existing_game) { Game.new(chat_id: fake_chat_id) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "user tries to assess the game's status" do
      message = Telegram::Bot::Types::Message.new(message_params('/status'))

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "parse_mode" => "Markdown",
                "text" => I18n.t(
                  "bot.commands.status.no_game",
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end
  end

  context "an active game exists" do
    scenario "user tries to assess the game's status" do
      message = Telegram::Bot::Types::Message.new(message_params("/status"))
      game = Game.create(chat_id: fake_chat_id, required_players: 5)
      default_url_options[:host] = ENV['APPLICATION_HOST']
      game.reload # to pull the UUID

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "parse_mode" => "Markdown",
                "text" => I18n.t(
                  "bot.commands.status.game_status",
                  game_url: game_url(game),
                  players: "0 / 5"
                )
              }
            )).to have_been_made.times(1)
    end
  end
end
