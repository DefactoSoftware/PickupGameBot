# == Schema Information
#
# Table name: players
#
#  id               :integer          not null, primary key
#  first_name       :string
#  last_name        :string
#  username         :string
#  telegram_user_id :integer
#

class Player < ActiveRecord::Base
  has_many :attendances
end
