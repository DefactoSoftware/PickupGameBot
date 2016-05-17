# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  longitude  :string
#  latitude   :string
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

class Location < ActiveRecord::Base
  belongs_to :game
end
