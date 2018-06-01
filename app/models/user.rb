class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :topics, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :nodes
  has_many :menus
end
