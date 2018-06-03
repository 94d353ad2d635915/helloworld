class Permission < ApplicationRecord
  has_one :menu, dependent: :destroy
  # has_and_belongs_to_many :roles, join_table: :assign_permissions_roles
  # extra attributes
  has_many :assign_permissions_roles, dependent: :destroy
  has_many :roles, through: :assign_permissions_roles
end
