class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :posttext, dependent: :destroy
  accepts_nested_attributes_for :posttext
  validates :title, presence: true
end
