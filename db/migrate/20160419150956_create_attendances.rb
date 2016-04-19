class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :game_id
      t.integer :player_id
    end

    add_foreign_key :attendances, :games
    add_foreign_key :attendances, :players
    add_index :attendances, [:game_id, :player_id], unique: true
  end
end
