# == Schema Information
#
# Table name: games
#
#  id               :integer          not null, primary key
#  name             :string
#  chat_id          :integer
#  start_time       :datetime
#  game             :string
#  required_players :integer          default(0)
#  longitude        :float
#  latitude         :float
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  uuid             :uuid
#  archived_at      :datetime
#  locations_id     :integer
#

class Game < ActiveRecord::Base
  extend BooleanDateTime
  has_one :location
  has_many :attendances
  has_many :players, through: :attendances

  boolean_date_time_field :archived_at, as: :archived
  scope :active, -> { where archived_at: nil }

  def to_param
    uuid
  end

  def archive!
    update(archived_at: DateTime.now)
  end
end
