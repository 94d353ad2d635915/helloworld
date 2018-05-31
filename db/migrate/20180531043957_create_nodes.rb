class CreateNodes < ActiveRecord::Migration[5.2]
  def up
    create_table :nodes do |t|
      t.references :node, foreign_key: true
      t.string :name
      t.string :slug
      t.string :tagline
      t.references :user, foreign_key: true
      t.references :posttext, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :nodes
  end
end
