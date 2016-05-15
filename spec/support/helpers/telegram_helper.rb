module TelegramHelper
  def chat_params
    {
      id: fake_chat_id,
      first_name: "Chet",
      last_name: "Faker",
      title: "Tuesday Futsal",
      type: "group",
      username: "chet_faker"
    }
  end

  def message_params(text, opts = {})
    message_params = {
      chat: telegram_chat,
      from: telegram_user,
      text: text,
      date: 1461013375,
      message_id: 92
    }
    message_params.merge(opts)
  end

  def user_params
    {
      first_name: "Chet",
      last_name: "Faker",
      username: "chet_faker",
      id: fake_user_id
    }
  end

  def fake_chat_id
    123
  end

  def fake_user_id
    789
  end
end
