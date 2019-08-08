# frozen_string_literal: true

require 'spec_helper'
require 'telegram/bot'
require 'pickup_bot'

feature 'set time ' do
  let(:bot) { Telegram::Bot::Client.new('fake-token') }
  let(:pickup_bot) { PickupBot.new(bot) }
  let(:telegram_user) { Telegram::Bot::Types::User.new(user_params) }
  let(:telegram_chat) { Telegram::Bot::Types::Chat.new(chat_params) }
  let(:existing_game) { Game.new(chat_id: fake_chat_id) }

  before :each do
    stub_request(:any, /api.telegram.org/).to_return(status: 200, body: '[]', headers: {})
  end

  context 'when no game currently exists' do
    scenario 'player tries to add a time' do
      message = Telegram::Bot::Types::Message.new(message_params('/set_time 06:00'))

      pickup_bot.run(message)

      expect(a_request(:post, 'https://api.telegram.org/botfake-token/sendMessage')
              .with(body: {
                      'chat_id' => '123',
                      'text' => I18n.t(
                        'bot.no_game',
                        username: user_params[:username]
                      )
                    })).to have_been_made.times(1)
    end
  end

  context 'when an active game exists' do
    before do
      Game.create(chat_id: fake_chat_id, required_players: 5)
    end

    scenario 'set the time to next week' do
      message = Telegram::Bot::Types::Message.new(message_params('/set_time next tuesday at 7pm'))

      pickup_bot.run(message)

      expect(a_request(:post, 'https://api.telegram.org/botfake-token/sendMessage')
              .with(body: {
                      'chat_id' => '123',
                      'text' => "The date is set to #{next_tuesday} 19:00"
                    })).to have_been_made.times(1)
    end

    scenario 'set the time to 7pm' do
      date = Date.today
      message = Telegram::Bot::Types::Message.new(message_params('/set_time 7pm'))

      pickup_bot.run(message)

      expect(a_request(:post, 'https://api.telegram.org/botfake-token/sendMessage')
              .with(body: {
                      'chat_id' => '123',
                      'text' => "The date is set to #{output_date(date)} 19:00"
                    })).to have_been_made.times(1)
    end

    scenario 'return a message when the date could not be formatted right' do
      message = Telegram::Bot::Types::Message.new(message_params('/set_time  '))

      pickup_bot.run(message)

      expect(a_request(:post, 'https://api.telegram.org/botfake-token/sendMessage')
              .with(body: {
                      'chat_id' => '123',
                      'text' => <<~HEREDOC
                        The chosen time could not be parsed to choose a time use
                        this command with a selected time, like:
                        /set_time 7pm
                        /set_time next tuesday
                        /set_time next thursday at 8pm
                      HEREDOC
                    })).to have_been_made.times(1)
    end
  end

  def next_tuesday
    today = Date.today
    return output_date(today) if today.tuesday

    (1..7).find { |t| (today + t).tuesday? }
          .then { |days| today + days }
          .then { |date| output_date(date) }
  end

  def output_date(date)
    "#{Date::MONTHNAMES[date.month]} #{date.mday}, #{date.year}"
  end
end
