class Creditlog < ApplicationRecord
  belongs_to :eventlog
  belongs_to :user
  has_one :event, through: :eventlog

  second_level_cache expires_in: 90.seconds
end
