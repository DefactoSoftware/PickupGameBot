require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "creating games" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "user creates game" do
      message = Telegram::Bot::Types::Message.new(message_params('/create_game'))

      pickup_bot.run(message)

      expect(Game.count).to eq(1)
      expect(Game.last.chat_id).to eq(fake_chat_id)
      expect(Game.last.name).to include(chat_params[:title])
      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  'bot.game_created',
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end

    scenario "user creates game with 8 required players" do
      message = Telegram::Bot::Types::Message.new(message_params('/create_game 8'))

      pickup_bot.run(message)

      expect(Game.count).to eq(1)
      expect(Game.last.required_players).to eq(8)
    end

    scenario "user creates game with 8 required players" do
      message = Telegram::Bot::Types::Message.new(message_params('/create_game 8'))

      pickup_bot.run(message)

      expect(Game.count).to eq(1)
      expect(Game.last.required_players).to eq(8)
    end
  end

  context "an active game already exists for this chat" do
    scenario "bot tells user a previous game is active" do
      message = Telegram::Bot::Types::Message.new(message_params('/create_game'))
      game = Game.create(chat_id: fake_chat_id)

      pickup_bot.run(message)

      expect(Game.count).to eq(1)
      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  'bot.game_exists',
                  username: user_params[:username]
                )
              }
            )).to have_been_made.times(1)
    end
  end
end
