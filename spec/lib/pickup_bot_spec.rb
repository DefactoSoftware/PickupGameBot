require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "user needs help" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }

  scenario "user asks for help" do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
    @user = Telegram::Bot::Types::User.new(user_params)
    @chat = Telegram::Bot::Types::Chat.new(chat_params)
    message = Telegram::Bot::Types::Message.new(message_params('help'))

    pickup_bot.run(message)

    expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage")).to have_been_made.times(1)
  end
end

feature "user creates a game" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
  end

  context "no game currently exists" do
    scenario "user creates game" do
      @user = Telegram::Bot::Types::User.new(user_params)
      @chat = Telegram::Bot::Types::Chat.new(chat_params)
      message = Telegram::Bot::Types::Message.new(message_params('/create_game'))

      pickup_bot.run(message)

      expect(Game.count).to eq(1)
      expect(Game.last.chat_id).to eq(fake_chat_id)
      expect(Game.last.name).to eq("Tuesday Futsal's game")
      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage")).to have_been_made.times(1)
    end
  end
end

private

def chat_params
  { id: fake_chat_id, first_name: "Chet", last_name: "Faker", title: "Tuesday Futsal", type: "group", username: "chet_faker" }
end

def message_params(text)
  { chat: @chat, from: @user, text: text, date: 1461013375, message_id: 92 }
end

def user_params
  { first_name: "Chet", last_name: "Faker", username: "chet_faker", id: fake_user_id }
end

def fake_chat_id
  123
end

def fake_user_id
  789
end

