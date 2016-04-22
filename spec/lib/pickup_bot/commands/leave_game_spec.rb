require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "leaving a game" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:existing_game) { Game.new(chat_id: fake_chat_id) }
  let(:message) { Telegram::Bot::Types::Message.new(message_params("/leave")) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "user tries to leave the non-existant game" do
      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.commands.leave.no_game",
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end
  end

  context "an active game exists" do
    scenario "user tries to leave a game he's not attending" do
      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.commands.leave.not_attending",
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end

    scenario "user leaves game he was previously attending" do
      game = Game.create(chat_id: fake_chat_id, required_players: 5)
      player = Player.find_by(telegram_user_id: message.from.id)
      Attendance.create(game: game, player: player)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.commands.leave.left",
                  username: user_params[:username],
                  players: "0 / 5"
                )
              }
            )).to have_been_made.times(1)

      expect(Attendance.count).to eq(0)
    end
  end
end
