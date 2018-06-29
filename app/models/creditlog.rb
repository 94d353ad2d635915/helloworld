class Creditlog < ApplicationRecord
  belongs_to :eventlog
  belongs_to :user
  has_one :event, through: :eventlog

  enum currency: instance_eval(OPTIONS['currencies'])

  second_level_cache expires_in: 90.seconds
end
