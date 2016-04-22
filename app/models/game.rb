class Game < ActiveRecord::Base
  extend BooleanDateTime
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
