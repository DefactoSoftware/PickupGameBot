require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "Set location of a game" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let!(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let!(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:location) { Telegram::Bot::Types::Location.new(longitude: 6.572751, latitude: 53.219275) }
  let(:message) { Telegram::Bot::Types::Message.new(message_params(nil, location: location)) }
  let(:existing_game) { create :game, chat_id: message.chat.id }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  scenario "user tries to archive the non-existent game" do
    existing_game
    pickup_bot.run(message)

    expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
      with(body: {
      "chat_id" => "123",
      "text" => I18n.t("bot.location_set")
    })).to have_been_made.times(1)
  end
end
