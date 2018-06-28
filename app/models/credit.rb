class Credit < ApplicationRecord
  belongs_to :user

  # second_level_cache expires_in: 90.seconds
  def to_param
    user_id.to_s
  end
end
