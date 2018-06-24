class Node < ApplicationRecord
  belongs_to :node, optional: true
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy
  has_many :topics
  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true

  second_level_cache expires_in: 90.seconds
  after_commit {Rails.cache.delete("#{self.class}_all")}
end
