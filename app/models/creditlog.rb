class Creditlog < ApplicationRecord
  belongs_to :eventlog
  belongs_to :user
  has_one :event, through: :eventlog
end
