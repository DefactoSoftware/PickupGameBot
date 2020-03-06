class AddHourAndMinutesToGame < ActiveRecord::Migration[4.2]
  def change
    add_column :games, :datetime, :datetime
  end
end
