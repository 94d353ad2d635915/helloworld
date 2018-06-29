class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :second_notifiable, polymorphic: true, optional: true
  belongs_to :third_notifiable, polymorphic: true, optional: true
  belongs_to :sender, :class_name => "User"

  enum _type: instance_eval(OPTIONS['Notification._types'])

  second_level_cache expires_in: 90.seconds
end
