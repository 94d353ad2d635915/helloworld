class Menu < ApplicationRecord
  has_many :menus, dependent: :nullify
  belongs_to :menu, optional: true
  belongs_to :permission, optional: true
  belongs_to :user

  validates :permission_id, uniqueness: true, allow_nil: true
  # attr_accessor :children
  attribute :children

  second_level_cache expires_in: 90.seconds
  after_commit {Rails.cache.delete_matched("#{self.class}*")}
end
