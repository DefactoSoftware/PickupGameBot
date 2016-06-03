include ActionDispatch::TestProcess

FactoryGirl.define do
  factory :player do
    first_name "Han"
    last_name "Solo"
    username "HSolo"
    telegram_user_id "123"
  end
end
