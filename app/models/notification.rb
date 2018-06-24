class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notifiable, polymorphic: true
  belongs_to :second_notifiable, polymorphic: true, optional: true
  belongs_to :third_notifiable, polymorphic: true, optional: true
  belongs_to :sender, :class_name => "User"

  enum _type: { commented: 1, metioned_at_comment: 2, metioned_at_topic: 3, thanksed: 4, faverited: 5, following: 6  }

  second_level_cache expires_in: 90.seconds
end
