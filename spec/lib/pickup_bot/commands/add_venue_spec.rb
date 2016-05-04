require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "joining a game" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:existing_game) { Game.new(chat_id: fake_chat_id) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "player tries to update venue anyway" do
      message = Telegram::Bot::Types::Message.new(message_params('/venue'))

      pickup_bot.run(message)

      expect(Player.count).to eq 0
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
    scenario "new player joins game, a new player is created" do
      venue = "kelder"
      message = Telegram::Bot::Types::Message.new(message_params("/venue #{venue}"))
      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.updated_venue",
                  venue: venue,
                )
              }
            )).to have_been_made.times(1)
      expect(Game.last.venue).to eq venue
    end
  end
end
