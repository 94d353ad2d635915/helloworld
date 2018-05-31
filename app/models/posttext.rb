class Posttext < ApplicationRecord
  belongs_to :textable, polymorphic: true
  validates :body, presence: true
end
