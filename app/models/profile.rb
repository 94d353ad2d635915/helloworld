class Profile < ApplicationRecord
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy
end
