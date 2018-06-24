class Posttext < ApplicationRecord
  belongs_to :textable, polymorphic: true
  validates :body, presence: true

  second_level_cache expires_in: 90.seconds
end
