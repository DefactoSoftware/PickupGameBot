class Attendance < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  validates_uniqueness_of :player_id, scope: :game_id

end
