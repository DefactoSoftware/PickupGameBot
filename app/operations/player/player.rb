require_relative "../../models/player"

class Player
  class Create < Operation::Base
    def self.run(telegram_user)
      new(telegram_user).run
    end

    def run(telegram_user)
      Player.find_or_create_by(telegram_user_id: telegram_user.id)
    end
  end
end
