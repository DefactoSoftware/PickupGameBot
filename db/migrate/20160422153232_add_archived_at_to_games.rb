class AddArchivedAtToGames < ActiveRecord::Migration
  def change
    add_column :games, :archived_at, :datetime
  end
end
