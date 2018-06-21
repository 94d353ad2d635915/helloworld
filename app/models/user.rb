class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :topics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :nodes
  has_many :menus
  # has_many :roles
  # has_and_belongs_to_many :users, join_table: :assign_roles_users
  # extra attributes
  has_many :assign_roles_users, dependent: :destroy
  has_many :roles, through: :assign_roles_users
  has_many :permissions, through: :roles
  # user.roles
  # user.permissions
  # not single assign permissions to user, must by role to assign permissions to user
  has_one :profile, dependent: :destroy
  has_many :eventlogs
  has_many :credits
  has_many :creditlogs
  has_many :notifications
end
