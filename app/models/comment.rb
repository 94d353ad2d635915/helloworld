class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :topic
  has_one :posttext, as: :textable, dependent: :destroy
  accepts_nested_attributes_for :posttext, allow_destroy: true, update_only: true

  after_create :send_notification_to_commented
  def send_notification_to_commented
    Notification.create(
      user_id: self.topic.user_id,
      sender_id: self.user_id,
      _type: Notification._types[:commented],
      notifiable: self.topic,
      second_notifiable: self
    ) if self.topic.user_id != self.user_id
  end
end
