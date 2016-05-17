class AddReferenceFromLocationToGame < ActiveRecord::Migration
  def change
    add_reference :locations, :game, index: true
  end
end
