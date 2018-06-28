class Posttext < ApplicationRecord
  belongs_to :textable, polymorphic: true
  validates :body, presence: true

  enum textable_type: { Topic: 1, Comment: 2, Node: 3, Message: 4 }

  second_level_cache expires_in: 90.seconds
end
