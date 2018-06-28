class Creditlog < ApplicationRecord
  belongs_to :eventlog
  belongs_to :user
  has_one :event, through: :eventlog

  enum currency: { POINT: 0, CNY: 1, BTC: 2, USD: 3 }

  second_level_cache expires_in: 90.seconds
end
