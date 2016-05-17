class AddAttachmentAvatarToPlayers < ActiveRecord::Migration
  def self.up
    change_table :players do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :players, :avatar
  end
end
