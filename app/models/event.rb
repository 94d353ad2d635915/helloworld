class Event < ApplicationRecord
  belongs_to :permission
  has_many :eventlogs, dependent: :destroy

  after_commit {Rails.cache.delete("#{self.class}_all")}
end
