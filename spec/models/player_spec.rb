# == Schema Information
#
# Table name: players
#
#  id                  :integer          not null, primary key
#  first_name          :string
#  last_name           :string
#  username            :string
#  telegram_user_id    :integer
#  avatar_file_name    :string
#  avatar_content_type :string
#  avatar_file_size    :integer
#  avatar_updated_at   :datetime
#

require "spec_helper"

describe Player, type: :model do
  describe "associations" do
    it { is_expected.to have_many :attendances }
  end

  describe "#avatar_url" do
    context "when it is set" do
      it "returns the uploaded image" do
        fake_picture = "#{Rails.root}/spec/fixtures/profile_picture.png"

        player = build(:player, first_name: "Harisson", last_name: "Ford",
                                username: "Han Solo", telegram_user_id: "123",
                                avatar: fixture_file_upload(fake_picture)
                              )

        expect(player.avatar_url).to eq(player.avatar.url(:original))
      end
    end
  end
end
