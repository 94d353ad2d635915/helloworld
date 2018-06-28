class Event < ApplicationRecord
  belongs_to :permission
  has_many :eventlogs, dependent: :destroy
  
  enum currency: { POINT: 0, CNY: 1, BTC: 2, USD: 3 }

  after_commit {Rails.cache.delete_matched("#{self.class}*")}
end
