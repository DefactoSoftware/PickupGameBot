require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "kicking a user" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:message) { Telegram::Bot::Types::Message.new(message_params("/kick OneTrickPony")) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  scenario "kick another user from a game" do
    game = Game.create(chat_id: fake_chat_id, required_players: 4)
    kicked_player = Player.create(telegram_user_id: 12, username: "OneTrickPony")
    Attendance.create(game: game, player: kicked_player)

    pickup_bot.run(message)

    expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
            with(body: {
              "chat_id" => "123",
              "text" => I18n.t(
                "bot.kick_user"
              )
            }
          )).to have_been_made.times(1)

      expect(Attendance.count).to eq(0)
  end
end
