class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # accepts_nested_attributes_for ..., reject_if: :all_blank_destroy
  def all_blank_destroy(attributes)
    attributes_empty = attributes.select{|k,v| !v.blank?}.empty?
    if self.valid? and attributes_empty
      attributes.merge!(_destroy: true)
      return false
    end
    attributes_empty
  end

  # for: [Menu,Node,Permission,Event,Role] _all
  # after_commit {Rails.cache.delete("#{self.class}_all")}
end
