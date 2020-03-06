class CreatePlayers < ActiveRecord::Migration[4.2]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.integer :telegram_user_id
    end
  end
end
