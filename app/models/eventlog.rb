class Eventlog < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one :creditlog, dependent: :destroy

  second_level_cache expires_in: 90.seconds
end
