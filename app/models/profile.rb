class Profile < ApplicationRecord
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy

  second_level_cache expires_in: 90.seconds
end
