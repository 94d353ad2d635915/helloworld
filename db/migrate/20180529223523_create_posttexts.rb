class CreatePosttexts < ActiveRecord::Migration[5.2]
  def up
    create_table :posttexts do |t|
      t.text :body
    end

    add_reference :topics, :posttext, foreign_key: true
    remove_column :topics, :body
  end

  def down
    drop_table :posttexts
    remove_reference :topics, :posttext, foreign_key: true
    add_column :topics, :body, :string
  end
end