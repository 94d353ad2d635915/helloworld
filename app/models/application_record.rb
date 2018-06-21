class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # accepts_nested_attributes_for ..., reject_if: :all_blank_destroy
  def all_blank_destroy(attributes)
    attributes.merge!(_destroy: true) if attributes.select{|k,v| !v.blank?}.empty?
    false
  end
end
