class Role < ApplicationRecord
  belongs_to :role, optional: true
  has_many :roles
  belongs_to :user
  # has_and_belongs_to_many :permissions, join_table: :assign_permissions_roles
  # extra attributes
  has_many :assign_permissions_roles, dependent: :destroy
  has_many :permissions, through: :assign_permissions_roles
  # has_and_belongs_to_many :users, join_table: :assign_roles_users
  # extra attributes
  has_many :assign_roles_users, dependent: :destroy
  has_many :users, through: :assign_roles_users
  # role 权限继承如何实现？
  # role 权限失效《删除》，下级叶子节点全部失效《删除》？
  # 获取 role 所有 下级节点的 role_ids,
  # *.
  validates :name, presence: true
  validates :name, uniqueness: true

  after_commit {Rails.cache.delete_matched("#{self.class}*")}
end
