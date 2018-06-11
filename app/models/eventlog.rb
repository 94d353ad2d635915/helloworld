class Eventlog < ApplicationRecord
  belongs_to :user
  belongs_to :event
  has_one :creditlog
end
