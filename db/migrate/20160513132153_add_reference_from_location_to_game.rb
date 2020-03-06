class AddReferenceFromLocationToGame < ActiveRecord::Migration[4.2]
  def change
    add_reference :locations, :game, index: true
  end
end
