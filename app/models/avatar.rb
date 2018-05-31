class Avatar < ApplicationRecord
  belongs_to :avatarable, polymorphic: true
  validates :url, presence: true
end
