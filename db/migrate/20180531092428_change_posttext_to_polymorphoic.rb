class ChangePosttextToPolymorphoic < ActiveRecord::Migration[5.2]
  def up
    drop_table :nodes
    drop_table :avatars
    drop_table :comments
    drop_table :topics
    drop_table :posttexts

    create_table :posttexts do |t|
      t.text :body
      t.references :textable, polymorphic: true, index: true
    end

    create_table :topics do |t|
      t.string :title
      t.references :user, foreign_key: true

      t.timestamps
    end

    create_table :comments do |t|
      t.references :user, foreign_key: true
      t.references :topic, foreign_key: true

      t.timestamps
    end

    create_table :avatars do |t|
      t.string :url
      t.references :avatarable, polymorphic: true, index: true
    end

    create_table :nodes do |t|
      t.references :node, foreign_key: true
      t.string :name
      t.string :slug
      t.string :tagline
      t.references :user, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :posttexts
    create_table :posttexts do |t|
      t.text :body
    end
    add_reference :topics, :posttext, foreign_key: true
    add_reference :comments, :posttext, foreign_key: true
    add_reference :nodes, :posttext, foreign_key: true
  end
end
