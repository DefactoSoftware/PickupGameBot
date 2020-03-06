class AddArchivedAtToGames < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :archived_at, :datetime
  end
end
