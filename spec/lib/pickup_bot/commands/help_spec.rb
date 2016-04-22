require "spec_helper"
require 'telegram/bot'
require 'pickup_bot'

feature "user needs help" do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }

  scenario "user asks for help" do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body:"[]", :headers => {})
    message = Telegram::Bot::Types::Message.new(message_params('help'))

    pickup_bot.run(message)

    expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
            with(body: {
              "chat_id" => "123",
                "text" => I18n.t(
                  'bot.whatever',
                  username: user_params[:username]
                )
              })
          ).to have_been_made.times(1)
  end
end
