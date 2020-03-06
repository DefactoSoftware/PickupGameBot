class AddUuidToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :uuid, :uuid, default: 'uuid_generate_v4()', index: true
  end
end
