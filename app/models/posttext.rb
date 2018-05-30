class Posttext < ApplicationRecord
  has_one :topic, dependent: :destroy
end
