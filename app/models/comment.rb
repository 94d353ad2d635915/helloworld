class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_one :posttext, as: :textable, dependent: :destroy
end
