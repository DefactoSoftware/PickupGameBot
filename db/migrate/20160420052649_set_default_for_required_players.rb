class SetDefaultForRequiredPlayers < ActiveRecord::Migration
  def up
    change_column_default :games, :required_players, 0
  end

  def down
    change_column_default :games, :required_players, nil
  end
end
