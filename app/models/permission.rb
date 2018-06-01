class Permission < ApplicationRecord
  has_one :menu, dependent: :destroy
end
