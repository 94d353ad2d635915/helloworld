class Topic < ApplicationRecord
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :node
  validates :title, :node_id, presence: true
end
