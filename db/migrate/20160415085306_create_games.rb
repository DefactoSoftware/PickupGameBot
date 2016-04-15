class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :chat_id
      t.datetime :start_time
      t.string :game
      t.integer :required_players
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end
  end
end
