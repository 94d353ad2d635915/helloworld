class Credit < ApplicationRecord
  belongs_to :user

  second_level_cache expires_in: 90.seconds
end
