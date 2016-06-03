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
    scenario "new player tries to join game" do
      message = Telegram::Bot::Types::Message.new(message_params('/join'))

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
      stub_avatar_request
      allow(bot.api).to receive(:get_user_profile_photos).and_return(stub_telegram_photos)
      allow(bot.api).to receive(:get_file).and_return(stub_file_hash)

      message = Telegram::Bot::Types::Message.new(message_params("/join"))
      game = Game.create(chat_id: fake_chat_id, required_players: 5)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.joined_game",
                  username: user_params[:username],
                  players: "1 / 5"
                )
              }
            )).to have_been_made.times(1)
      expect(Player.count).to eq 1
      expect(Game.last.attendances.count).to eq 1
      expect(Player.last.avatar_file_name).to_not eq nil
      expect(Player.last.first_name).to eq message.from.first_name
    end

    scenario "existing player joins game" do
      message = Telegram::Bot::Types::Message.new(message_params("/join"))
      game = Game.create(chat_id: fake_chat_id, required_players: 5)
      player = Player.create(telegram_user_id: telegram_user.id)

      pickup_bot.run(message)

      expect(a_request(:post, "https://api.telegram.org/botfake-token/sendMessage").
              with(body: {
                "chat_id" => "123",
                "text" => I18n.t(
                  "bot.joined_game",
                  username: user_params[:username],
                  players: "1 / 5"
                )
              }
            )).to have_been_made.times(1)
      expect(Player.count).to eq 1
      expect(Game.last.attendances.count).to eq 1
    end
  end


  private
  def stub_telegram_photos
    {"ok"=>true,
     "result"=>
    {"total_count"=>1,
     "photos"=>
    [[{"file_id"=>"fake-file-id", "file_size"=>8786, "width"=>160, "height"=>160},
      {"file_id"=>"fake-file-id-2", "file_size"=>23897, "width"=>320, "height"=>320},
      {"file_id"=>"fake-file-id-3", "file_size"=>62566, "width"=>640, "height"=>640}]]}}
  end

  def stub_file_hash
    {"ok"=>true, "result"=>{"file_id"=> "fake-file-id", "file_size"=>8786, "file_path"=>"photo/file_0.jpg"}}
  end


  def stub_avatar_request
    stub_request(:get, "https://api.telegram.org/file/bot143293395:AAHiPFb9qZYYRckQGRt5IJTlGG8KsHFh6X8/photo/file_0.jpg").
      with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
      to_return(
        :status => 200,
        :body => File.open(File.join(Rails.root, '/spec/fixtures/profile_picture.png')),
        :headers => { content_type: "image/png" })
  end
end
