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

class Player < ActiveRecord::Base
  has_many :attendances, dependent: :destroy
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "100x100>" },
    default_url: "/images/:style/missing.png"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/

  def avatar_url
    avatar.url(:original)
  end
end
