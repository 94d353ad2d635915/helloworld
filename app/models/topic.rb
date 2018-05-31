class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :posttext, optional: true, dependent: :destroy
  has_many :comments, dependent: :destroy
  accepts_nested_attributes_for :posttext
  validates :title, presence: true
end
