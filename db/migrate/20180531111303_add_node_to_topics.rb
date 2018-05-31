class AddNodeToTopics < ActiveRecord::Migration[5.2]
  def change
    add_reference :topics, :node, foreign_key: true
  end
end
