class Posttext < ApplicationRecord
  has_one :topic
  has_one :comment, dependent: :destroy
  validates :body, presence: true
end
