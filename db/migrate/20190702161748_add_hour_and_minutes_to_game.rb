class AddHourAndMinutesToGame < ActiveRecord::Migration
  def change
    add_column :games, :datetime, :datetime
  end
end
