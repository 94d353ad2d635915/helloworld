class Menu < ApplicationRecord
  belongs_to :menu, optional: true
  belongs_to :permission, optional: true
  belongs_to :user

  validates :permission_id, uniqueness: true, allow_nil: true
  # attr_accessor :children
  attribute :children
end
