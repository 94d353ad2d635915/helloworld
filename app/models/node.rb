class Node < ApplicationRecord
  belongs_to :node, optional: true
  belongs_to :user
  has_one :avatar, as: :avatarable, dependent: :destroy
  has_one :posttext, as: :textable, dependent: :destroy
  validates :name, :slug, presence: true
  validates :name, :slug, uniqueness: true
end
