class Profile < ApplicationRecord
  belongs_to :user
  has_one :avatar, as: :avatarable, dependent: :destroy
  has_one :posttext, as: :textable, dependent: :destroy
end
