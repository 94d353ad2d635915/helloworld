class Posttext < ApplicationRecord
  has_one :topic, dependent: :destroy
  has_one :comment, dependent: :destroy
end
