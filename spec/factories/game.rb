include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :game do
    chat_id 1234
    start_time DateTime.now
    required_players 8
    archived_at nil
    location
  end
end
