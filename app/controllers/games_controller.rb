# == Schema Information
#
# Table name: games
#
#  id               :integer          not null, primary key
#  name             :string
#  chat_id          :integer
#  start_time       :datetime
#  game             :string
#  required_players :integer          default(0)
#  longitude        :float
#  latitude         :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uuid             :uuid
#  archived_at      :datetime
#

class GamesController < ApplicationController
  def index
    @games = Game.all
  end

  def show
    @game = Game.find_by(uuid: params[:id])
  end
end
