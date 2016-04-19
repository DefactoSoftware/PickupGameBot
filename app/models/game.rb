class Game < ActiveRecord::Base
  has_many :attendances
  has_many :players, through: :attendances

  def to_param
    uuid
  end
end
