module Operation
  class Base
    def self.run(game, player, &block)
      new(game, player).run(&block)
    end

    def initialize(game, player)
      @game = game
      @player = player
    end
  end

  require "attendance/attendance"
  require "player/player"
end
