# == Schema Information
#
# Table name: attendances
#
#  id        :integer          not null, primary key
#  game_id   :integer
#  player_id :integer
#

class Attendance < ActiveRecord::Base
  belongs_to :game
  belongs_to :player
  validates_uniqueness_of :player_id, scope: :game_id

end
