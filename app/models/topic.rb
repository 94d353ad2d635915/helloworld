class Topic < ApplicationRecord
  belongs_to :user
  has_one :posttext, as: :textable, dependent: :destroy
  accepts_nested_attributes_for :posttext, allow_destroy: true, reject_if: :all_blank_destroy, update_only: true
  has_many :comments, dependent: :destroy
  belongs_to :node
  validates :title, :node_id, presence: true

  second_level_cache expires_in: 90.seconds
end
