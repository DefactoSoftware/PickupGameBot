class AddVenueToGame < ActiveRecord::Migration
  def change
    add_column :games, :venue, :string
  end
end
