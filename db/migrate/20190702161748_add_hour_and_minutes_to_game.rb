class AddHourAndMinutesToGame < ActiveRecord::Migration
  def change
    add_column :games, :time, :string
    add_column :games, :date, :string
  end
end
