class AddUuidToGames < ActiveRecord::Migration
  def change
    add_column :games, :uuid, :uuid, default: 'uuid_generate_v4()', index: true
  end
end
