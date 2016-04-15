class GamesController < ApplicationController
  def show
    @games = Game.all
  end
end
