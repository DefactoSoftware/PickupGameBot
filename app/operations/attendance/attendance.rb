require_relative "../../models/attendance"

class Attendance
  class Create < Operation::Base
    # def self.run(game, player)
    #   pp 'we here'
    #   new(game, player).run
    # end

    def run(&block)
      pp "attendance run"

      Attendance.create(game: @game, player: @player)
    end
  end
end
