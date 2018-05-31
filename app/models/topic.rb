class Topic < ApplicationRecord
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :title, presence: true
end
