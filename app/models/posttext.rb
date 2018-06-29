class Posttext < ApplicationRecord
  belongs_to :textable, polymorphic: true
  validates :body, presence: true

  enum textable_type: instance_eval(OPTIONS['Posttext.textable_types'])

  second_level_cache expires_in: 90.seconds
end
