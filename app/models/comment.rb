class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  belongs_to :posttext, dependent: :destroy
  accepts_nested_attributes_for :posttext
end
