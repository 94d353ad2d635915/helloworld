class Event < ApplicationRecord
  belongs_to :permission
  has_many :eventlogs, dependent: :destroy
  
  enum currency: instance_eval(OPTIONS['currencies'])

  after_commit {Rails.cache.delete_matched("#{self.class}*")}
end
